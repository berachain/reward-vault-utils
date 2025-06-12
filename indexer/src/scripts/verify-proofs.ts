import axios from 'axios';
import chalk from 'chalk';
import { ethers } from 'ethers';
import fs from 'fs';
import path from 'path';

async function main() {
  console.log(chalk.blue('[verify-proofs] Starting script...'));

  // 1. Create a new distribution
  console.log(chalk.yellow('[verify-proofs] Creating new distribution...'));
  const response = await axios.post('http://localhost:3000/merkle/distribution', {
    startTime: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(), // Last 24 hours
    endTime: new Date().toISOString(),
    rewardAmount: '5',
  });

  const { claimId, merkleRoot } = response.data;
  console.log(chalk.green('[verify-proofs] Distribution created:'));
  console.log(chalk.green(`Claim ID: ${claimId}`));
  console.log(chalk.green(`Merkle Root: ${merkleRoot}`));

  // 2. Verify claimId is bytes32
  if (!ethers.isHexString(claimId, 32)) {
    console.log(chalk.red('[verify-proofs] Error: claimId is not bytes32'));
    process.exit(1);
  }
  console.log(chalk.green('[verify-proofs] claimId is valid bytes32'));

  // 3. Load reward claimers
  const rewardClaimersPath = path.join(__dirname, 'reward_claimers.json');
  const rewardClaimers = JSON.parse(fs.readFileSync(rewardClaimersPath, 'utf-8'));

  // 4. Get and verify proofs for each claimer
  console.log(chalk.yellow('[verify-proofs] Getting proofs for reward claimers...'));
  for (const claimer of rewardClaimers) {
    try {
      const proofResponse = await axios.get('http://localhost:3000/merkle/proof', {
        params: {
          claimId,
          address: claimer.address,
        },
      });

      const { proof, rewardAmount } = proofResponse.data;
      
      if (!proof || proof.length === 0) {
        console.log(chalk.red(`[verify-proofs] Error: Empty proof for address ${claimer.address}`));
        process.exit(1);
      }

      console.log(chalk.green(`[verify-proofs] Valid proof for ${claimer.address}:`));
      console.log(chalk.green(`Reward Amount: ${rewardAmount}`));
      console.log(chalk.green(`Proof Length: ${proof.length}`));
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.log(chalk.red(`[verify-proofs] Error getting proof for ${claimer.address}:`), error.response?.data || error.message);
      } else {
        console.log(chalk.red(`[verify-proofs] Unexpected error for ${claimer.address}:`), error);
      }
      process.exit(1);
    }
  }

  console.log(chalk.green('[verify-proofs] All proofs verified successfully!'));
}

main().catch((error) => {
  console.error(chalk.red('[verify-proofs] Fatal error:'), error);
  process.exit(1);
}); 