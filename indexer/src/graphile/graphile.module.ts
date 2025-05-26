import { Module } from '@nestjs/common';
import { GraphileService } from './graphile.service';

@Module({
  providers: [GraphileService],
  exports: [GraphileService],
})
export class GraphileModule {} 