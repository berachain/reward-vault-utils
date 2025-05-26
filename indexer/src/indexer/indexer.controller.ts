import { Controller, OnModuleInit, Logger } from '@nestjs/common';
import { IndexerService } from './indexer.service';
import { GraphileService, GraphileWorkerPattern } from '../graphile/graphile.service';

@Controller()
export class IndexerController implements OnModuleInit {
  private readonly logger = new Logger(IndexerController.name);

  constructor(
    private readonly indexerService: IndexerService,
    private readonly graphileService: GraphileService,
  ) {}

  async onModuleInit() {
    // Schedule recurring invocation of indexButtonPresses every 30 seconds
    await this.graphileService.addJob(
      GraphileWorkerPattern.INDEX_FROM,
      {},
      { runAt: new Date(), repeatInterval: '30 seconds' }
    );
  }
} 