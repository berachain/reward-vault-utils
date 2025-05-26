import { Injectable } from '@nestjs/common';
import { makeWorkerUtils, WorkerUtils } from 'graphile-worker';

export enum GraphileWorkerPattern {
  INDEX_FROM = 'indexFrom',
}

@Injectable()
export class GraphileService {
  private workerUtils: WorkerUtils;

  constructor() {
    this.initializeWorker();
  }

  private async initializeWorker() {
    this.workerUtils = await makeWorkerUtils({
      connectionString: process.env.DATABASE_URL,
    });
  }

  async addJob(pattern: GraphileWorkerPattern, payload: any, options: any) {
    await this.workerUtils.addJob(pattern, payload, options);
  }
} 