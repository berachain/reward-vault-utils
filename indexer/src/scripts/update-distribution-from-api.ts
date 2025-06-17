import axios from 'axios';
import fs from 'fs';
import path from 'path';

async function main() {
  const rewardClaimersPath = path.join(__dirname, 'reward_claimers.json');
  const distributionPath = path.join(__dirname, '../merkle/examples/distribution.json');
  const claimers = JSON.parse(fs.readFileSync(rewardClaimersPath, 'utf-8'));

  // 1. Create a new distribution
  // Use the same time window and reward as before, or prompt for them if needed
  // For now, use the earliest and latest timestamps from the previous distribution.json if available
  let startTime, endTime, rewardAmount;
  try {
    const prevDist = JSON.parse(fs.readFileSync(distributionPath, 'utf-8'));
    startTime = prevDist.distribution.start;
    endTime = prevDist.distribution.end;
    // Convert prizeAmount (wei) to tokens
    rewardAmount = (BigInt(prevDist.distribution.prizeAmount) / 10n ** 18n).toString();
  } catch {
    // Fallback defaults
    startTime = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();
    endTime = new Date().toISOString();
    rewardAmount = '5';
  }

  const distRes = await axios.post('http://localhost:3000/merkle/distribution', {
    startTime,
    endTime,
    rewardAmount,
  });
  const { claimId, merkleRoot, participantCount, start, end, prizeAmount } = distRes.data;
  console.log('[update-distribution-from-api] Created distribution:', claimId, merkleRoot);

  // 2. For each address, get proof and rewardAmount
  const participants = [];
  for (const claimer of claimers) {
    const address = claimer.address;
    try {
      const proofRes = await axios.get('http://localhost:3000/merkle/proof', {
        params: { claimId, address },
      });
      const { proof, rewardAmount } = proofRes.data;
      participants.push({ address, rewardAmount, proof });
      console.log(`[update-distribution-from-api] Got proof for ${address}:`, proof.length, 'nodes');
    } catch (err) {
      console.error(`[update-distribution-from-api] Error getting proof for ${address}:`, err.response?.data || err.message);
      participants.push({ address, rewardAmount: '0', proof: [] });
    }
  }

  // 3. Write new distribution.json
  const newDist = {
    distribution: {
      claimId,
      merkleRoot,
      participantCount,
      start,
      end,
      prizeAmount,
    },
    participants,
  };
  fs.writeFileSync(distributionPath, JSON.stringify(newDist, null, 2));
  console.log('[update-distribution-from-api] distribution.json updated!');
}

main().catch((err) => {
  console.error('[update-distribution-from-api] Fatal error:', err);
  process.exit(1);
}); 