import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { IndexerModule } from './indexer/indexer.module';
import { PrismaModule } from './prisma/prisma.module';
import { GraphileModule } from './graphile/graphile.module';
import { MerkleModule } from './merkle/merkle.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    IndexerModule,
    PrismaModule,
    GraphileModule,
    MerkleModule,
  ],
})
export class AppModule {} 