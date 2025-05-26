import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { Button__factory, Button } from '../types';
import { ethers } from 'ethers';

const CHUNK_SIZE = 1000;
const FINALITY = 5;

@Injectable()
export class IndexerService implements OnModuleInit {
  private provider: ethers.JsonRpcProvider;
  private button: Button;
  private readonly logger = new Logger(IndexerService.name);

  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {}

  async onModuleInit() {
    const rpcUrl = this.configService.get<string>('RPC_URL');
    const buttonAddress = this.configService.get<string>('BUTTON_CONTRACT_ADDRESS');
    if (!rpcUrl || !buttonAddress) {
      throw new Error('RPC_URL and BUTTON_CONTRACT_ADDRESS must be set in environment');
    }
    this.provider = new ethers.JsonRpcProvider(rpcUrl);
    this.button = Button__factory.connect(buttonAddress, this.provider);

    // Start the indexer
    const startBlock = await this.getLastProcessedBlock() + 1;
    await this.indexButtonPresses(startBlock);
  }

  async getLastProcessedBlock(): Promise<number> {
    const state = await this.prisma.indexerState.findUnique({ where: { key: 'lastProcessedBlock' } });
    return state ? parseInt(state.value, 10) : 0; // 0 or your deployment block
  }

  async setLastProcessedBlock(block: number) {
    await this.prisma.indexerState.upsert({
      where: { key: 'lastProcessedBlock' },
      update: { value: String(block) },
      create: { key: 'lastProcessedBlock', value: String(block) },
    });
  }

  async indexButtonPresses(startBlock: number) {
    let latestBlock = await this.provider.getBlockNumber();
    let toBlock = latestBlock - FINALITY;
    let fromBlock = startBlock;

    while (fromBlock <= toBlock) {
      const endBlock = Math.min(fromBlock + CHUNK_SIZE - 1, toBlock);

      this.logger.log(`Indexing blocks ${fromBlock} to ${endBlock}...`);

      const events = await this.button.queryFilter(
        this.button.filters.ButtonPressed(),
        fromBlock,
        endBlock
      );

      await this.prisma.$transaction(async (tx: PrismaService) => {
        for (const event of events) {
          const { user, timestamp } = event.args;
          await tx.buttonPress.upsert({
            where: { txHash: event.transactionHash },
            update: {},
            create: {
              address: user,
              timestamp: new Date(Number(timestamp) * 1000),
              blockNumber: event.blockNumber,
              txHash: event.transactionHash,
            },
          });
        }
        await tx.indexerState.upsert({
          where: { key: 'lastProcessedBlock' },
          update: { value: String(endBlock) },
          create: { key: 'lastProcessedBlock', value: String(endBlock) },
        });
      });

      fromBlock = endBlock + 1;
    }
    this.logger.log('Indexer caught up to chain head.');
  }

  // Method to get button presses within a time window
  async getButtonPressesInTimeWindow(startTime: Date, endTime: Date) {
    return this.prisma.buttonPress.findMany({
      where: {
        timestamp: {
          gte: startTime,
          lte: endTime,
        },
      },
    });
  }

  // Method to get button press counts by address within a time window
  async getButtonPressCountsByAddress(startTime: Date, endTime: Date) {
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
    return await this.provider.getBlockNumber();
  }
} 