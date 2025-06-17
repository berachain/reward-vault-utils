import { Test, TestingModule } from '@nestjs/testing';
import { MerkleService } from './merkle.service';
import { PrismaService } from '../prisma/prisma.service';
import { keccak256, concatBytes } from 'viem';
import { describe, it, expect, beforeEach, jest } from '@jest/globals';
import { encodeAbiParameters, parseUnits } from 'viem';

describe('MerkleService', () => {
  let service: MerkleService;
  let prismaService: PrismaService;

  const mockPrismaService: any = {
    buttonPress: {
      groupBy: jest.fn(),
    },
    merkleClaim: {
      create: jest.fn(),
    },
    merkleParticipant: {
      findUnique: jest.fn(),
    },
    $transaction: jest.fn((callback: (prisma: any) => Promise<any>) => callback(mockPrismaService)),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MerkleService,
        {
          provide: PrismaService,
          useValue: mockPrismaService,
        },
      ],
    }).compile();

    service = module.get<MerkleService>(MerkleService);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('generateMerkleClaim', () => {
    it('should generate a merkle claim with correct metadata and proofs', async () => {
      const start = new Date('2023-01-01');
      const end = new Date('2023-01-02');
      const totalReward = '1.0'; // 1 ETH

      const mockPresses = [
        { address: '0x1234567890123456789012345678901234567890', _count: { address: 2 } },
        { address: '0x4567890123456789012345678901234567890123', _count: { address: 3 } },
      ];

      mockPrismaService.buttonPress.groupBy.mockResolvedValue(mockPresses);

      const result = await service.generateMerkleClaim(start, end, totalReward);

      expect(result).toBeDefined();
      expect(result.claimId).toBeDefined();
      expect(result.merkleRoot).toBeDefined();
      expect(result.participantCount).toBe(2);
      expect(result.start).toEqual(start);
      expect(result.end).toEqual(end);
      expect(result.prizeAmount).toBeDefined();

      expect(mockPrismaService.merkleClaim.create).toHaveBeenCalled();
    });

    it('should throw an error if no button presses are found', async () => {
      const start = new Date('2023-01-01');
      const end = new Date('2023-01-02');
      const totalReward = '1.0';

      mockPrismaService.buttonPress.groupBy.mockResolvedValue([]);

      await expect(service.generateMerkleClaim(start, end, totalReward)).rejects.toThrow('No button presses in the given window');
    });

    it('should generate different merkle roots for different date ranges', async () => {
      const start1 = new Date('2023-01-01');
      const end1 = new Date('2023-01-02');
      const start2 = new Date('2023-01-03');
      const end2 = new Date('2023-01-04');
      const totalReward = '1.0';

      const mockPresses = [
        { address: '0x1234567890123456789012345678901234567890', _count: { address: 2 } },
        { address: '0x4567890123456789012345678901234567890123', _count: { address: 3 } },
      ];

      mockPrismaService.buttonPress.groupBy.mockResolvedValue(mockPresses);

      const result1 = await service.generateMerkleClaim(start1, end1, totalReward);
      const result2 = await service.generateMerkleClaim(start2, end2, totalReward);

      expect(result1.merkleRoot).not.toBe(result2.merkleRoot);
    });

    it('should generate different claim IDs for the same date range', async () => {
      const start = new Date('2023-01-01');
      const end = new Date('2023-01-02');
      const totalReward = '1.0';

      const mockPresses = [
        { address: '0x1234567890123456789012345678901234567890', _count: { address: 2 } },
        { address: '0x4567890123456789012345678901234567890123', _count: { address: 3 } },
      ];

      mockPrismaService.buttonPress.groupBy.mockResolvedValue(mockPresses);

      const result1 = await service.generateMerkleClaim(start, end, totalReward);
      const result2 = await service.generateMerkleClaim(start, end, totalReward);

      expect(result1.claimId).not.toBe(result2.claimId);
    });
  });

  describe('generateMerkleTree', () => {
    it('should generate a merkle tree with correct root and layers', () => {
      const leaves = [
        '0x1234567890123456789012345678901234567890123456789012345678901234',
        '0x4567890123456789012345678901234567890123456789012345678901234567',
        '0x7890123456789012345678901234567890123456789012345678901234567890',
      ];
      const bufferLeaves = leaves.map(l => Buffer.from(l.slice(2), 'hex'));
      const result = service.generateMerkleTree(bufferLeaves);
      expect(result.root).toBeDefined();
      expect(result.leaves).toEqual(bufferLeaves.map(l => '0x' + l.toString('hex')));
      expect(result.layers.length).toBeGreaterThan(1);
    });
  });

  describe('generateProof', () => {
    it('should generate a valid merkle proof for a leaf', () => {
      const leaves = [
        '0x1234567890123456789012345678901234567890123456789012345678901234',
        '0x4567890123456789012345678901234567890123456789012345678901234567',
        '0x7890123456789012345678901234567890123456789012345678901234567890',
      ];
      const bufferLeaves = leaves.map(l => Buffer.from(l.slice(2), 'hex'));
      const tree = service.generateMerkleTree(bufferLeaves);
      const proof = service.generateProof(bufferLeaves, 0, tree.layers);
      expect(proof).toBeDefined();
      expect(Array.isArray(proof)).toBe(true);
    });
  });

  describe('getUserProof', () => {
    it('should return a user proof for a valid claim and address', async () => {
      const claimId = '0x1234567890123456789012345678901234567890123456789012345678901234';
      const address = '0x1234567890123456789012345678901234567890';
      const mockParticipant = {
        claimId,
        address,
        rewardAmount: '1000000000000000000',
        proof: ['0x1234567890123456789012345678901234567890123456789012345678901234'],
        claim: { merkleRoot: '0xmerkleRoot' },
      };

      mockPrismaService.merkleParticipant.findUnique.mockResolvedValue(mockParticipant);

      const result = await service.getUserProof(claimId, address);

      expect(result).toBeDefined();
      expect(result.rewardAmount).toBe(mockParticipant.rewardAmount);
      expect(result.proof).toEqual(mockParticipant.proof);
      expect(result.merkleRoot).toBe(mockParticipant.claim.merkleRoot);
    });

    it('should throw an error if no proof is found', async () => {
      const claimId = '0x1234567890123456789012345678901234567890123456789012345678901234';
      const address = '0x1234567890123456789012345678901234567890';

      mockPrismaService.merkleParticipant.findUnique.mockResolvedValue(null);

      await expect(service.getUserProof(claimId, address)).rejects.toThrow('No proof found for this address');
    });
  });
}); 