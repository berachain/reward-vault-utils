import { Controller, Post, Get, Body, Query } from '@nestjs/common';
import { MerkleService } from './merkle.service';

@Controller('merkle')
export class MerkleController {
  constructor(private readonly merkleService: MerkleService) {}

  @Post('distribution')
  async createMerkleDistribution(
    @Body('startTime') startTime: string,
    @Body('endTime') endTime: string,
    @Body('rewardAmount') rewardAmount: string,
  ) {
    const result = await this.merkleService.generateMerkleClaim(
      new Date(startTime),
      new Date(endTime),
      rewardAmount,
    );
    return {
      claimId: result.claimId,
      merkleRoot: result.merkleRoot,
      participantCount: result.participantCount,
      start: result.start,
      end: result.end,
      prizeAmount: result.prizeAmount,
    };
  }

  @Get('proof')
  async getProof(
    @Query('claimId') claimId: string,
    @Query('address') address: string,
  ) {
    return this.merkleService.getUserProof(claimId, address);
  }
} 