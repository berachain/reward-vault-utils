import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { randomBytes } from 'crypto';
import { bytesToHex } from 'viem';
import { Prisma } from '@prisma/client';
import { keccak256, concat, toBytes, pad, parseUnits } from 'viem';
import { encodePacked } from 'viem';

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
  async generateMerkleClaim(start: Date | string, end: Date | string, totalReward: string) {
    // Parse ISO strings to Date objects if needed
    const startDate = start instanceof Date ? start : new Date(start);
    const endDate = end instanceof Date ? end : new Date(end);

    // 1. Get all button presses grouped by address
    const presses = await this.prisma.buttonPress.groupBy({
      by: ['address'],
      where: {
        timestamp: {
          gte: startDate,
          lte: endDate,
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
    console.log('[merkle.service] Participants for this claim:');
    participants.forEach((p, i) => {
      console.log(`  [${i}] address: ${p.address}, count: ${p.count}, reward: ${p.reward}`);
    });

    // 5. Adjust for rounding error (ensure sum == totalRewardWei)
    let distributed = participants.reduce((sum: bigint, p: { reward: string }) => sum + BigInt(p.reward), 0n);
    let diff = BigInt(totalRewardWei) - distributed;
    if (diff !== 0n) {
      participants[0].reward = (BigInt(participants[0].reward) + diff).toString();
    }

    // 6. Generate a claim id (random or hash)
    const claimId = bytesToHex(randomBytes(32), { size: 32 }) as `0x${string}`;
    console.log('[merkle.service] Generated claimId:', claimId, 'length:', claimId.length);
    // Ensure claimId is 0x + 64 hex chars
    if (claimId.length !== 66) {
      throw new Error('Generated claimId is not bytes32: ' + claimId);
    }

    // 7. Build Merkle tree: leaf = keccak256(abi.encodePacked(claimId, address, token, rewardAmount))
    const FBGT = '0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece';
    
    // Build leaves exactly as Solmate expects them
    const leaves = participants.map((p: { address: string; reward: string }) => {
      // Create the packed data exactly as Solidity would with abi.encodePacked
      const packed = Buffer.concat([
        Buffer.from(claimId.slice(2), 'hex'), // bytes32
        Buffer.from(p.address.slice(2), 'hex'), // address
        Buffer.from(FBGT.slice(2), 'hex'), // address
        Buffer.from(BigInt(p.reward).toString(16).padStart(64, '0'), 'hex'), // uint256
      ]);
      // Hash the packed data to create the leaf
      const leaf = keccak256(packed);
      console.log(`[merkle.service] Leaf for ${p.address}: ${leaf}`);
      return leaf;
    });

    // Create Merkle tree with keccak256 for both leaves and internal nodes
    const { MerkleTree } = require('merkletreejs');
    const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
    const merkleRoot = '0x' + tree.getRoot().toString('hex');
    console.log('[merkle.service] Computed Merkle root:', merkleRoot);

    // 8. Store MerkleClaim and MerkleParticipant records
    await this.prisma.$transaction(async (tx: PrismaService) => {
      const claimData: Prisma.MerkleClaimCreateInput = {
        claimId,
        merkleRoot,
        start: startDate,
        end: endDate,
        prizeAmount: totalRewardWei,
        participantCount: participants.length,
        participants: {
          create: participants.map((p: { address: string; reward: string }, i: number) => {
            // Get proof for this leaf by index and ensure it's in the format Solmate expects
            const proof = tree.getProof(leaves[i]).map((x: any) => {
              const proofHex = '0x' + x.data.toString('hex');
              // Ensure the proof is exactly 32 bytes (64 hex chars + 0x)
              if (proofHex.length !== 66) {
                throw new Error(`Invalid proof length for ${p.address}: ${proofHex.length}`);
              }
              return proofHex;
            });
            console.log(`[merkle.service] Proof for ${p.address}:`, proof);
            return {
              address: p.address,
              rewardAmount: p.reward,
              proof,
            };
          }),
        },
      };
      await tx.merkleClaim.create({ data: claimData });
    });

    return {
      claimId,
      merkleRoot,
      participantCount: participants.length,
      start: startDate,
      end: endDate,
      prizeAmount: totalRewardWei,
    };
  }

  // Build a Merkle tree and return root and all layers
  public generateMerkleTree(leaves: Buffer[]) {
    // Use hashLeaves: true and sortPairs: true
    const { MerkleTree } = require('merkletreejs');
    const keccak256 = require('keccak256');
    const tree = new MerkleTree(leaves, keccak256, { hashLeaves: true, sortPairs: true });
    // Get all layers for proof generation
    let layers = tree.getLayers().map((layer: Buffer[]) => layer.map((n: Buffer) => '0x' + n.toString('hex')));
    return {
      root: '0x' + tree.getRoot().toString('hex'),
      leaves: leaves.map(l => '0x' + l.toString('hex')),
      layers,
      tree,
    };
  }

  // Generate a Merkle proof for a leaf at a given index
  public generateProof(leaves: Buffer[], index: number, layers: string[][]): string[] {
    const { MerkleTree } = require('merkletreejs');
    const keccak256 = require('keccak256');
    const tree = new MerkleTree(leaves, keccak256, { hashLeaves: true, sortPairs: true });
    const proof = tree.getProof(leaves[index]).map((p: { data: Buffer }) => '0x' + p.data.toString('hex'));
    console.log(`[merkle.service] generateProof for leaf[${index}]:`, leaves[index], 'proof:', proof);
    return proof;
  }

  // Retrieve a user's proof for a given claim/root and address
  async getUserProof(claimId: string, address: string) {
    console.log(`[merkle.service] getUserProof called with claimId=${claimId}, address=${address}`);
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
      console.log(`[merkle.service] No proof found for address ${address} and claimId ${claimId}`);
      throw new Error('No proof found for this address');
    }

    console.log(`[merkle.service] Returning proof for address ${address}:`, participant.proof);
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