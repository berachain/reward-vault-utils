import axios from 'axios';
import chalk from 'chalk';
import { PrismaClient } from '@prisma/client';

async function main() {
  console.log(chalk.blue('[create-distribution] Starting script...'));
  const prisma = new PrismaClient();

  console.log(chalk.yellow('[create-distribution] Fetching earliest and latest button press timestamps...'));
  const earliest = await prisma.buttonPress.findFirst({ orderBy: { timestamp: 'asc' } });
  const latest = await prisma.buttonPress.findFirst({ orderBy: { timestamp: 'desc' } });

  if (!earliest || !latest) {
    console.log(chalk.red('[create-distribution] No button presses found in the database.'));
    process.exit(1);
  }

  const startTime = earliest.timestamp.toISOString();
  const endTime = latest.timestamp.toISOString();
  const rewardAmount = '5';

  console.log(chalk.green(`[create-distribution] Using startTime=${startTime}, endTime=${endTime}, rewardAmount=${rewardAmount}`));

  try {
    console.log(chalk.yellow('[create-distribution] Calling /merkle/distribution API...'));
    const response = await axios.post('http://localhost:3000/merkle/distribution', {
      startTime,
      endTime,
      rewardAmount,
    });
    console.log(chalk.green('[create-distribution] Distribution created successfully:'));
    console.log(response.data);
  } catch (error) {
    if (axios.isAxiosError(error)) {
      console.log(chalk.red('[create-distribution] API error:'), error.response?.data || error.message);
    } else {
      console.log(chalk.red('[create-distribution] Unexpected error:'), error);
    }
    process.exit(1);
  }
}

main(); 