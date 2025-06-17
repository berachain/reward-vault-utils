import axios from 'axios';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';

async function main() {
  console.log(chalk.blue('[verify-proofs] Starting script...'));

  // 1. Get the latest distribution from the API
  console.log(chalk.yellow('[verify-proofs] Fetching latest distribution from API...'));
  // This assumes the latest distribution is the most recent one created; if you have a GET endpoint for this, use it.
  // Otherwise, you may need to POST to /merkle/distribution with the same params as last time.
  // For now, let's read the local distribution.json for participants, but update claimId/merkleRoot from the API.
  const distributionPath = path.join(__dirname, '../merkle/examples/distribution.json');
  let distribution = JSON.parse(fs.readFileSync(distributionPath, 'utf-8'));

  // Option 1: If you have a GET endpoint for the latest distribution, use it here.
  // Option 2: If not, you must POST to /merkle/distribution with the same params as last time.
  // We'll use the local file for participants, but update claimId/root from the API response.

  // Example: POST to /merkle/distribution with the same params as last time
  const { start, end, prizeAmount } = distribution.distribution;
  let apiDistribution;
  try {
    const response = await axios.post('http://localhost:3000/merkle/distribution', {
      startTime: start,
      endTime: end,
      rewardAmount: (BigInt(prizeAmount) / 10n ** 18n).toString(), // convert wei to tokens
    });
    apiDistribution = response.data;
    console.log(chalk.green('[verify-proofs] Got latest distribution from API:'));
    console.log(apiDistribution);
  } catch (error) {
    console.error(chalk.red('[verify-proofs] Error fetching distribution from API:'), error);
    process.exit(1);
  }

  // 2. For each participant, get their proof from the API
  const participants = distribution.participants;
  for (const participant of participants) {
    try {
      const proofResponse = await axios.get('http://localhost:3000/merkle/proof', {
        params: {
          claimId: apiDistribution.claimId,
          address: participant.address,
        },
      });
      const { proof, rewardAmount } = proofResponse.data;
      participant.proof = proof;
      participant.rewardAmount = rewardAmount;
      console.log(chalk.green(`[verify-proofs] Updated proof for ${participant.address}`));
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.log(chalk.red(`[verify-proofs] Error getting proof for ${participant.address}:`), error.response?.data || error.message);
      } else {
        console.log(chalk.red(`[verify-proofs] Unexpected error for ${participant.address}:`), error);
      }
      process.exit(1);
    }
  }

  // 3. Write the updated distribution.json
  const newDistribution = {
    distribution: {
      claimId: apiDistribution.claimId,
      merkleRoot: apiDistribution.merkleRoot,
      participantCount: apiDistribution.participantCount,
      start: apiDistribution.start,
      end: apiDistribution.end,
      prizeAmount: apiDistribution.prizeAmount,
    },
    participants,
  };
  fs.writeFileSync(distributionPath, JSON.stringify(newDistribution, null, 2));
  console.log(chalk.green('[verify-proofs] distribution.json updated via API!'));
}

main().catch((error) => {
  console.error(chalk.red('[verify-proofs] Fatal error:'), error);
  process.exit(1);
}); 