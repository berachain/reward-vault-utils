import { keccak256 } from 'viem';
import { MerkleTree } from 'merkletreejs';
import fs from 'fs';
import path from 'path';

// Load the latest distribution
const distributionPath = path.join(__dirname, '../merkle/examples/distribution.json');
const distribution = JSON.parse(fs.readFileSync(distributionPath, 'utf-8'));

const { claimId, merkleRoot } = distribution.distribution;
const token = '0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece';
const participants = distribution.participants;

// Build leaves exactly as merkle service does
const leaves = participants.map(p => {
  // Create the packed data exactly as Solidity would with abi.encodePacked
  const packed = Buffer.concat([
    Buffer.from(claimId.slice(2), 'hex'), // bytes32
    Buffer.from(p.address.slice(2), 'hex'), // address
    Buffer.from(token.slice(2), 'hex'), // address
    Buffer.from(BigInt(p.rewardAmount).toString(16).padStart(64, '0'), 'hex'), // uint256
  ]);
  // Hash the packed data to create the leaf
  const leaf = keccak256(packed);
  console.log(`Leaf for ${p.address}: ${leaf}`);
  return Buffer.from(leaf.slice(2), 'hex');
});

// Create Merkle tree with keccak256 for both leaves and internal nodes
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const computedRoot = '0x' + tree.getRoot().toString('hex');

console.log('Computed Merkle root:', computedRoot);
console.log('Expected Merkle root:', merkleRoot);

// Verify each participant's proof
participants.forEach((p, i) => {
  const leaf = leaves[i];
  const proof = p.proof.map((x: string) => Buffer.from(x.slice(2), 'hex'));
  const valid = tree.verify(proof, leaf, Buffer.from(merkleRoot.slice(2), 'hex'));
  console.log(`Participant ${i + 1} (${p.address}): Proof valid?`, valid);
}); 