import { Injectable, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { makeWorkerUtils, WorkerUtils } from 'graphile-worker';

export enum GraphileWorkerPattern {
  INDEX_FROM = 'indexFrom',
}

@Injectable()
export class GraphileService implements OnModuleInit {
  private workerUtils: WorkerUtils;

  constructor(private configService: ConfigService) {}

  async onModuleInit() {
    await this.initializeWorker();
  }

  private async initializeWorker() {
    const connectionString = this.configService.get<string>('DATABASE_URL');
    if (!connectionString) {
      throw new Error('DATABASE_URL must be set in environment');
    }
    this.workerUtils = await makeWorkerUtils({
      connectionString,
    });
  }

  async addJob(pattern: GraphileWorkerPattern, payload: any, options: any) {
    await this.workerUtils.addJob(pattern, payload, options);
  }
} 