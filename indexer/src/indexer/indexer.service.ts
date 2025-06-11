import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { createPublicClient, http, getContract, parseAbiItem } from 'viem';

const CHUNK_SIZE = 1000;
const FINALITY = 5;

@Injectable()
export class IndexerService implements OnModuleInit {
  private logger = new Logger(IndexerService.name);
  private client: ReturnType<typeof createPublicClient>;
  private buttonContract: ReturnType<typeof getContract>;

  constructor(
    private readonly configService: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

  async onModuleInit() {
    const rpcUrl = this.configService.get<string>('RPC_URL');
    const buttonAddress = this.configService.get<string>('BUTTON_CONTRACT_ADDRESS');
    if (!rpcUrl || !buttonAddress) {
      this.logger.error('Missing required environment variables: RPC_URL and BUTTON_CONTRACT_ADDRESS');
      throw new Error('RPC_URL and BUTTON_CONTRACT_ADDRESS must be set in environment');
    }
    this.client = createPublicClient({
      transport: http(rpcUrl),
      chain: undefined, // Optionally set chain config
    });
    this.buttonContract = getContract({
      address: buttonAddress as `0x${string}`,
      abi: [
        // Replace with actual ABI or import from abis/
        parseAbiItem('event ButtonPressed(address indexed user, uint256 timestamp)'),
      ],
      client: this.client,
    });
    this.logger.log(`Connected to button contract at: ${buttonAddress}`);
    await this.indexButtonPresses();
  }

  async indexButtonPresses(startBlock?: number) {
    const fromBlock = startBlock ?? 0;
    const latestBlock = await this.client.getBlockNumber();
    const toBlock = latestBlock;
    const logs = await this.client.getLogs({
      address: this.buttonContract.address,
      event: parseAbiItem('event ButtonPressed(address indexed user, uint256 timestamp)'),
      fromBlock,
      toBlock,
    });
    this.logger.log(`Found ${logs.length} button press events in blocks ${fromBlock}-${toBlock}`);
    for (const log of logs) {
      const { user, timestamp } = log.args as any;
      this.logger.debug(`Processing button press from ${user} at block ${log.blockNumber}`);
      await this.prisma.buttonPress.upsert({
        where: {
          txHash: log.transactionHash,
        },
        update: {},
        create: {
          txHash: log.transactionHash,
          user,
          timestamp: new Date(Number(timestamp) * 1000),
          blockNumber: Number(log.blockNumber),
        },
      });
    }
  }

  async getLastProcessedBlock(): Promise<number> {
    const state = await this.prisma.indexerState.findUnique({ where: { key: 'lastProcessedBlock' } });
    const block = state ? parseInt(state.value, 10) : 0;
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

    return presses.map((press: { address: string; _count: { address: number } }) => ({
      address: press.address,
      count: press._count.address,
    }));
  }

  async getCurrentBlock(): Promise<number> {
    const block = await this.client.getBlockNumber();
    this.logger.debug(`Current block: ${block}`);
    return block;
  }
} 