import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { createPublicClient, http, getContract, parseAbiItem, type Address } from 'viem';
import { berachainBepolia } from 'viem/chains';
import { setTimeout } from 'timers/promises';

const CHUNK_SIZE = 1000;
const FINALITY = 5;

const BUTTON_ABI = [
  parseAbiItem('event ButtonPressed(address indexed user, uint256 timestamp)'),
  parseAbiItem('function canPressButton(address account) view returns (bool)'),
  parseAbiItem('function pressButton()'),
  parseAbiItem('function lastPressTime(address account) view returns (uint256)'),
  parseAbiItem('function COOLDOWN_PERIOD() view returns (uint256)'),
] as const;

@Injectable()
export class IndexerService implements OnModuleInit {
  private readonly logger = new Logger(IndexerService.name);
  private readonly BATCH_SIZE = 10000;
  // TODO: Revisit type safety for viem client and contract
  private client: any;
  private buttonContract: any;

  constructor(
    private readonly configService: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

  async onModuleInit() {
    this.logger.log('Initializing indexer service...');
    const rpcUrl = this.configService.get<string>('RPC_URL');
    const buttonAddress = this.configService.get<string>('BUTTON_CONTRACT_ADDRESS');
    
    if (!rpcUrl || !buttonAddress) {
      this.logger.error('Missing required environment variables: RPC_URL and BUTTON_CONTRACT_ADDRESS');
      throw new Error('RPC_URL and BUTTON_CONTRACT_ADDRESS must be set in environment');
    }

    this.logger.log(`Connecting to RPC: ${rpcUrl}`);
    this.client = createPublicClient({
      transport: http(rpcUrl),
      chain: berachainBepolia,
    }) as any;

    this.buttonContract = getContract({
      address: buttonAddress as Address,
      abi: BUTTON_ABI,
      client: this.client,
    }) as any;

    this.logger.log(`Connected to button contract at: ${buttonAddress}`);

    // Start the indexer
    const state = await this.prisma.indexerState.findUnique({ 
      where: { key: 'lastProcessedBlock' } 
    });
    const startBlock = state ? parseInt(state.value, 10) : 5000000;
    this.logger.log(`Starting indexer from block ${startBlock}`);
    await this.indexButtonPresses(startBlock);
  }

  async getLastProcessedBlock(): Promise<number> {
    const state = await this.prisma.indexerState.findUnique({ 
      where: { key: 'lastProcessedBlock' } 
    });
    const block = state ? parseInt(state.value, 10) : 5000000;
    this.logger.debug(`Last processed block: ${block}`);
    return block;
  }

  async setLastProcessedBlock(block: number) {
    this.logger.debug(`Setting last processed block to: ${block}`);
    await this.prisma.indexerState.upsert({
      where: { key: 'lastProcessedBlock' },
      update: { value: String(block) },
      create: { key: 'lastProcessedBlock', value: String(block) },
    });
  }

  async indexButtonPresses(startBlock: number) {
    try {
      const latestBlock = await this.client.getBlockNumber();
      const fromBlock = BigInt(startBlock);
      const toBlock = latestBlock - BigInt(FINALITY);

      this.logger.log(`Indexing from block ${fromBlock} to ${toBlock} (latest: ${latestBlock})`);

      const chunkSize = BigInt(this.BATCH_SIZE);
      let currentBlock = fromBlock;

      while (currentBlock < toBlock) {
        const endBlock = currentBlock + chunkSize > toBlock ? toBlock : currentBlock + chunkSize;
        this.logger.log(`Processing blocks ${currentBlock} to ${endBlock}...`);

        const logs = await this.client.getLogs({
          address: this.buttonContract.address,
          event: parseAbiItem('event ButtonPressed(address indexed presser)'),
          fromBlock: currentBlock,
          toBlock: endBlock,
        });

        if (logs.length === 0) {
          this.logger.log(`[ButtonPress] No events found in blocks ${currentBlock} to ${endBlock}`);
        }

        for (const log of logs) {
          const { presser } = log.args;
          this.logger.log(`[ButtonPress] Block: ${log.blockNumber}, Tx: ${log.transactionHash}, Presser: ${presser}`);

          // Fetch the block to get the timestamp
          const block = await this.client.getBlock({ blockHash: log.blockHash });

          await this.prisma.buttonPress.create({
            data: {
              address: presser,
              timestamp: new Date(Number(block.timestamp) * 1000),
              blockNumber: Number(log.blockNumber),
              txHash: log.transactionHash,
            },
          });
        }

        await this.setLastProcessedBlock(Number(endBlock));
        currentBlock = endBlock + 1n;
        await setTimeout(1000); // 1 second delay
      }
    } catch (error) {
      this.logger.error(`Error processing blocks: ${error}`);
      throw error;
    }
  }

  async getButtonPressesInTimeWindow(startTime: Date, endTime: Date) {
    this.logger.debug(`Fetching button presses from ${startTime} to ${endTime}`);
    return this.prisma.buttonPress.findMany({
      where: {
        timestamp: {
          gte: startTime,
          lte: endTime,
        },
      },
    });
  }

  async getButtonPressCountsByAddress(startTime: Date, endTime: Date) {
    this.logger.debug(`Fetching button press counts from ${startTime} to ${endTime}`);
    const presses = await this.prisma.buttonPress.groupBy({
      by: ['address'],
      where: {
        timestamp: {
          gte: startTime,
          lte: endTime,
        },
      },
      _count: {
        address: true,
      },
    });

    return presses.map((press) => ({
      address: press.address,
      count: press._count.address,
    }));
  }

  async getCurrentBlock(): Promise<number> {
    const block = await this.client.getBlockNumber();
    this.logger.debug(`Current block: ${block}`);
    return Number(block);
  }
} 