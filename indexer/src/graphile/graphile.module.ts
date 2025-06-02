import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { GraphileService } from './graphile.service';

@Module({
  imports: [ConfigModule],
  providers: [GraphileService],
  exports: [GraphileService],
})
export class GraphileModule {} 