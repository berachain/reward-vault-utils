import { Module } from '@nestjs/common';
import { IndexerService } from './indexer.service';
import { IndexerController } from './indexer.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { GraphileModule } from '../graphile/graphile.module';

@Module({
  imports: [PrismaModule, GraphileModule],
  providers: [IndexerService],
  controllers: [IndexerController],
  exports: [IndexerService],
})
export class IndexerModule {} 