import { Module } from '@nestjs/common';
import { MerkleService } from './merkle.service';
import { MerkleController } from './merkle.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [MerkleService],
  controllers: [MerkleController],
  exports: [MerkleService],
})
export class MerkleModule {} 