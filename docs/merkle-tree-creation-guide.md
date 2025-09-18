# Merkle Tree Creation Guide

This guide explains how to create Merkle trees for reward distribution using the Reward Vault Utils system. This implementation follows Solidity-compatible standards and can be used independently.

## Overview

Merkle trees are used to efficiently verify that a participant is eligible for a reward without revealing the entire distribution list. Each participant can prove their reward amount using a Merkle proof that validates against the tree's root.

## Key Components

### 1. Leaf Structure

Each leaf in the Merkle tree represents a participant's claim and is constructed as:

```typescript
// Leaf = keccak256(abi.encodePacked(claimId, address, tokenAddress, rewardAmount))
const packed = Buffer.concat([
  Buffer.from(claimId.slice(2), 'hex'),           // bytes32
  Buffer.from(address.slice(2), 'hex'),           // address (20 bytes)
  Buffer.from(tokenAddress.slice(2), 'hex'),      // address (20 bytes)
  Buffer.from(BigInt(rewardAmount).toString(16).padStart(64, '0'), 'hex'), // uint256
]);
const leaf = keccak256(packed);
```

### 2. Tree Construction

The Merkle tree is built using the `merkletreejs` library with specific configuration:

```typescript
import { MerkleTree } from 'merkletreejs';
import { keccak256 } from 'viem';

const tree = new MerkleTree(leaves, keccak256, { 
  sortPairs: true  // Important for Solidity compatibility
});
```

## Complete Implementation

Here's a complete example of how to create a Merkle tree for reward distribution:

```typescript
import { randomBytes } from 'crypto';
import { bytesToHex, keccak256, parseUnits } from 'viem';
import { MerkleTree } from 'merkletreejs';

export interface Participant {
  address: string;
  count: number;
  reward: string;
  index: number;
}

export class MerkleTreeCreator {
  
  /**
   * Generate a complete Merkle claim with tree and proofs
   */
  async generateMerkleClaim(
    participants: Participant[], 
    totalReward: string,
    tokenAddress: string = '0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece'
  ) {
    
    // 1. Generate unique claim ID
    const claimId = bytesToHex(randomBytes(32), { size: 32 }) as `0x${string}`;
    
    // 2. Convert total reward to wei
    const totalRewardWei = parseUnits(totalReward, 18).toString();
    
    // 3. Calculate proportional rewards
    const totalPresses = participants.reduce((sum, p) => sum + p.count, 0);
    const participantsWithRewards = participants.map((p, i) => {
      const reward = BigInt(totalRewardWei) * BigInt(p.count) / BigInt(totalPresses);
      return {
        address: p.address,
        count: p.count,
        reward: reward.toString(),
        index: i,
      };
    });
    
    // 4. Adjust for rounding errors
    let distributed = participantsWithRewards.reduce((sum, p) => sum + BigInt(p.reward), 0n);
    let diff = BigInt(totalRewardWei) - distributed;
    if (diff !== 0n) {
      participantsWithRewards[0].reward = (BigInt(participantsWithRewards[0].reward) + diff).toString();
    }
    
    // 5. Build Merkle tree leaves
    const leaves = participantsWithRewards.map((p) => {
      const packed = Buffer.concat([
        Buffer.from(claimId.slice(2), 'hex'),           // bytes32
        Buffer.from(p.address.slice(2), 'hex'),         // address
        Buffer.from(tokenAddress.slice(2), 'hex'),      // address
        Buffer.from(BigInt(p.reward).toString(16).padStart(64, '0'), 'hex'), // uint256
      ]);
      return keccak256(packed);
    });
    
    // 6. Create Merkle tree
    const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
    const merkleRoot = '0x' + tree.getRoot().toString('hex');
    
    // 7. Generate proofs for each participant
    const participantsWithProofs = participantsWithRewards.map((p, i) => {
      const proof = tree.getProof(leaves[i]).map((x: any) => {
        const proofHex = '0x' + x.data.toString('hex');
        if (proofHex.length !== 66) {
          throw new Error(`Invalid proof length for ${p.address}: ${proofHex.length}`);
        }
        return proofHex;
      });
      
      return {
        address: p.address,
        rewardAmount: p.reward,
        proof,
      };
    });
    
    return {
      claimId,
      merkleRoot,
      participantCount: participantsWithRewards.length,
      prizeAmount: totalRewardWei,
      participants: participantsWithProofs,
    };
  }
  
  /**
   * Generate a simple Merkle tree from leaves
   */
  generateMerkleTree(leaves: Buffer[]) {
    const tree = new MerkleTree(leaves, keccak256, { 
      hashLeaves: true, 
      sortPairs: true 
    });
    
    const layers = tree.getLayers().map((layer: Buffer[]) => 
      layer.map((n: Buffer) => '0x' + n.toString('hex'))
    );
    
    return {
      root: '0x' + tree.getRoot().toString('hex'),
      leaves: leaves.map(l => '0x' + l.toString('hex')),
      layers,
      tree,
    };
  }
  
  /**
   * Generate a Merkle proof for a specific leaf
   */
  generateProof(leaves: Buffer[], index: number): string[] {
    const tree = new MerkleTree(leaves, keccak256, { 
      hashLeaves: true, 
      sortPairs: true 
    });
    
    return tree.getProof(leaves[index]).map((p: { data: Buffer }) => 
      '0x' + p.data.toString('hex')
    );
  }
}
```

## Usage Example

```typescript
// Example usage
const creator = new MerkleTreeCreator();

const participants = [
  { address: '0x90783200B25740db5df651b866b6089f9D47F7cf', count: 1, reward: '0', index: 0 },
  { address: '0x90F52a77f49B43535ddc4750E4d0456617E13F98', count: 1, reward: '0', index: 1 },
  { address: '0xA62d803C3bEA46382DcDa549Ba59C676A6c8c211', count: 1, reward: '0', index: 2 },
];

const result = await creator.generateMerkleClaim(participants, '5.0'); // 5 BERA total reward

console.log('Claim ID:', result.claimId);
console.log('Merkle Root:', result.merkleRoot);
console.log('Participants:', result.participants.length);
```

## Solidity Verification

The generated Merkle tree can be verified in Solidity using libraries like Solmate's `MerkleProof`:

```solidity
import { MerkleProofLib } from "solmate/utils/MerkleProofLib.sol";

function verifyClaim(
    bytes32 claimId,
    address participant,
    address token,
    uint256 rewardAmount,
    bytes32[] calldata proof,
    bytes32 merkleRoot
) public pure returns (bool) {
    bytes32 leaf = keccak256(abi.encodePacked(claimId, participant, token, rewardAmount));
    return MerkleProofLib.verify(proof, merkleRoot, leaf);
}
```

## Key Points

1. **Leaf Construction**: Each leaf must be constructed exactly as shown to match Solidity's `abi.encodePacked` behavior
2. **Sorting**: Always use `sortPairs: true` for Solidity compatibility
3. **Hash Function**: Use `keccak256` for both leaves and internal nodes
4. **Proof Format**: Proofs must be exactly 32 bytes (66 hex characters including 0x)
5. **Rounding**: Handle rounding errors by adjusting the first participant's reward
6. **Claim ID**: Use a cryptographically secure random 32-byte value for each claim

## Dependencies

```json
{
  "dependencies": {
    "merkletreejs": "^0.4.0",
    "viem": "^1.0.0"
  }
}
```

This implementation ensures compatibility with Solidity smart contracts and provides a robust foundation for reward distribution systems.
