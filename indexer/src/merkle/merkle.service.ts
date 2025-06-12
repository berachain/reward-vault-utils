import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { randomBytes } from 'crypto';
import { bytesToHex } from 'viem';
import { Prisma } from '@prisma/client';
import { keccak256, concatBytes, encodeAbiParameters, parseUnits, ByteArray, hexToBytes } from 'viem';

export interface ButtonPress {
  address: string;
  count: number;
  reward: string;
  index: number;
}

@Injectable()
export class MerkleService {
  constructor(private prisma: PrismaService) {}

  // Generate a Merkle claim and store all proofs and metadata
  async generateMerkleClaim(start: Date, end: Date, totalReward: string) {
    // 1. Get all button presses grouped by address
    const presses = await this.prisma.buttonPress.groupBy({
      by: ['address'],
      where: {
        timestamp: {
          gte: start,
          lte: end,
        },
      },
      _count: {
        address: true,
      },
    });
    console.log('[merkle.service] Number of button presses found:', presses.length);
    if (presses.length === 0) {
      throw new Error('No button presses in the given window');
    }

    // 2. Calculate total presses
    const totalPresses = presses.reduce((sum: number, p: { address: string; _count: { address: number } }) => sum + p._count.address, 0);
    // 3. Convert totalReward to wei (string)
    const totalRewardWei = parseUnits(totalReward, 18).toString();

    // 4. Calculate each user's reward (in wei, as string)
    const participants = presses.map((press: { address: string; _count: { address: number } }, i: number) => {
      // Proportional reward
      let reward = BigInt(totalRewardWei) * BigInt(press._count.address) / BigInt(totalPresses);
      return {
        address: press.address,
        count: press._count.address,
        reward: reward.toString(),
        index: i,
      };
    });

    // 5. Adjust for rounding error (ensure sum == totalRewardWei)
    let distributed = participants.reduce((sum: bigint, p: { reward: string }) => sum + BigInt(p.reward), 0n);
    let diff = BigInt(totalRewardWei) - distributed;
    if (diff !== 0n) {
      // Add/subtract the difference to the first participant
      participants[0].reward = (BigInt(participants[0].reward) + diff).toString();
    }

    // 6. Generate a claim id (random or hash)
    const claimId = bytesToHex(randomBytes(32), { size: 32 }) as `0x${string}`;
    console.log('[merkle.service] Generated claimId:', claimId, 'length:', claimId.length);
    // Ensure claimId is 0x + 64 hex chars
    if (claimId.length !== 66) {
      throw new Error('Generated claimId is not bytes32: ' + claimId);
    }

    // 7. Build Merkle tree: leaf = keccak256(abi.encode(claimId, address, rewardAmount))
    const leaves = participants.map((p: { address: string; reward: string }) =>
      keccak256(encodeAbiParameters(
        [
          { type: 'bytes32' },
          { type: 'address' },
          { type: 'uint256' }
        ],
        [claimId, p.address as `0x${string}`, BigInt(p.reward)]
      ))
    );
    const tree = this.generateMerkleTree(leaves);
    const merkleRoot = tree.root;

    // 8. Store MerkleClaim and MerkleParticipant records
    await this.prisma.$transaction(async (tx: PrismaService) => {
      const claimData: Prisma.MerkleClaimCreateInput = {
        claimId,
        merkleRoot,
        start,
        end,
        prizeAmount: totalRewardWei,
        participantCount: participants.length,
        participants: {
          create: participants.map((p: { address: string; reward: string }, i: number) => ({
            address: p.address,
            rewardAmount: p.reward,
            proof: this.generateProof(leaves, i, tree.layers),
          })),
        },
      };
      await tx.merkleClaim.create({ data: claimData });
    });

    return {
      claimId,
      merkleRoot,
      participantCount: participants.length,
      start,
      end,
      prizeAmount: totalRewardWei,
    };
  }

  // Build a Merkle tree and return root and all layers
  public generateMerkleTree(leaves: string[]) {
    let layers: string[][] = [leaves];
    let nodes = leaves;
    while (nodes.length > 1) {
      const newNodes = [];
      for (let i = 0; i < nodes.length; i += 2) {
        if (i + 1 === nodes.length) {
          newNodes.push(nodes[i]);
        } else {
          newNodes.push(
            keccak256(concatBytes([hexToBytes(nodes[i] as `0x${string}`), hexToBytes(nodes[i + 1] as `0x${string}`)]))
          );
        }
      }
      layers.push(newNodes);
      nodes = newNodes;
    }
    return {
      root: nodes[0],
      leaves,
      layers,
    };
  }

  // Generate a Merkle proof for a leaf at a given index
  public generateProof(leaves: string[], index: number, layers: string[][]): string[] {
    let proof: string[] = [];
    let idx = index;
    for (let i = 0; i < layers.length - 1; i++) {
      const layer = layers[i];
      const pairIndex = idx % 2 === 0 ? idx + 1 : idx - 1;
      if (pairIndex < layer.length) {
        proof.push(layer[pairIndex]);
      }
      idx = Math.floor(idx / 2);
    }
    return proof;
  }

  // Retrieve a user's proof for a given claim/root and address
  async getUserProof(claimId: string, address: string) {
    const participant = await this.prisma.merkleParticipant.findUnique({
      where: {
        claimId_address: {
          claimId,
          address,
        },
      },
      include: {
        claim: true,
      },
    });

    if (!participant) {
      throw new Error('No proof found for this address');
    }

    return {
      address: participant.address,
      rewardAmount: participant.rewardAmount,
      proof: participant.proof,
      merkleRoot: participant.claim.merkleRoot,
    };
  }

  // Method to get button presses within a time window
  async getButtonPressesInTimeWindow(startTime: Date, endTime: Date): Promise<ButtonPress[]> {
    const presses = await this.prisma.buttonPress.groupBy({
      by: ['address'],
      where: {
        timestamp: {
          gte: startTime,
          lte: endTime,
        },
      },
      _count: {
        address: true,
      },
    });

    return presses.map((press: { address: string; _count: { address: number } }, i: number) => ({
      address: press.address,
      count: press._count.address,
      reward: '0', // Placeholder, adjust as needed
      index: i,
    }));
  }
} 