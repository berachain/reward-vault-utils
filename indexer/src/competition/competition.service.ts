import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ButtonPress, CompetitionPeriod, RewardClaim } from '@prisma/client';
import { ethers } from 'ethers';
import { MerkleTree } from 'merkletreejs';
import keccak256 from 'keccak256';

@Injectable()
export class CompetitionService {
  constructor(private prisma: PrismaService) {}

  async recordButtonPress(userId: string, txHash: string): Promise<ButtonPress> {
    return this.prisma.buttonPress.create({
      data: {
        userId,
        txHash,
      },
    });
  }

  async createCompetitionPeriod(
    startTime: Date,
    endTime: Date,
    distributionId: number,
  ): Promise<CompetitionPeriod> {
    return this.prisma.competitionPeriod.create({
      data: {
        startTime,
        endTime,
        distributionId,
      },
    });
  }

  async updatePeriodMerkleRoot(
    distributionId: number,
    merkleRoot: string,
    totalPresses: number,
  ): Promise<CompetitionPeriod> {
    return this.prisma.competitionPeriod.update({
      where: { distributionId },
      data: {
        merkleRoot,
        totalPresses,
      },
    });
  }

  async generateMerkleTree(distributionId: number): Promise<MerkleTree> {
    const period = await this.prisma.competitionPeriod.findUnique({
      where: { distributionId },
    });

    if (!period) {
      throw new Error('Competition period not found');
    }

    const presses = await this.prisma.buttonPress.findMany({
      where: {
        timestamp: {
          gte: period.startTime,
          lte: period.endTime,
        },
      },
    });

    const leaves = presses.map(press => 
      keccak256(
        ethers.AbiCoder.defaultAbiCoder().encode(
          ['uint256', 'address', 'uint256'],
          [distributionId, press.userId, 1] // 1 BGT per press
        )
      )
    );

    return new MerkleTree(leaves, keccak256, { sortPairs: true });
  }

  async createRewardClaim(
    userId: string,
    distributionId: number,
    amount: string,
    merkleProof: string,
  ): Promise<RewardClaim> {
    return this.prisma.rewardClaim.create({
      data: {
        userId,
        distributionId,
        amount,
        merkleProof,
      },
    });
  }

  async markRewardClaimed(claimId: string): Promise<RewardClaim> {
    return this.prisma.rewardClaim.update({
      where: { id: claimId },
      data: {
        claimed: true,
        claimedAt: new Date(),
      },
    });
  }

  async getUnclaimedRewards(userId: string): Promise<RewardClaim[]> {
    return this.prisma.rewardClaim.findMany({
      where: {
        userId,
        claimed: false,
      },
    });
  }
} 