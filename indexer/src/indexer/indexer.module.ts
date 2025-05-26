import { Module } from '@nestjs/common';
import { IndexerService } from './indexer.service';
import { IndexerController } from './indexer.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [IndexerService],
  controllers: [IndexerController],
  exports: [IndexerService],
})
export class IndexerModule {} 