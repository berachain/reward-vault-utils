import 'dotenv/config';
import { createPublicClient, http, createWalletClient } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import type { Address } from 'viem';
import { berachainBepolia } from 'viem/chains';
import { readFileSync, existsSync, writeFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import chalk from 'chalk';
import readline from 'readline';

/**
 * Button Press Script
 * 
 * This script processes button presses for a list of addresses from reward_claimers.json.
 * Each address can only press the button once per hour (cooldown period).
 * 
 * Example output:
 * Script started...
 * Current directory: /home/jintao/Documents/berachain/competition-vault/indexer/src/scripts
 * Reward claimers file path: /home/jintao/Documents/berachain/competition-vault/indexer/src/scripts/reward_claimers.json
 * Button contract address: 0x3DE5C1118bfecB5DE628FDE9b3e0c72FEE66b7f2
 * RPC URL: https://bepolia.rpc.berachain.com
 * Found 5 existing claimers in reward_claimers.json
 * Do you want to load these addresses? (y/n): y
 * Processing 5 claimers
 * 
 * Processing claimer: 0x90783200B25740db5df651b866b6089f9D47F7cf
 * Address 0x90783200B25740db5df651b866b6089f9D47F7cf last pressed at 1970-01-01T00:00:00.000Z
 * Time since last press: 1749677628 seconds
 * Cooldown period: 3600 seconds
 * Can press button - pressing now
 * Successfully pressed button for 0x90783200B25740db5df651b866b6089f9D47F7cf. Tx hash: 0x355f8f111b23923e2ede83af315e488f148536dd1fd8ac73ef390c2f1075504d
 */

console.log('Script started...');

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

console.log('Current directory:', __dirname);

const REWARD_CLAIMERS_FILE = join(__dirname, 'reward_claimers.json');
console.log('Reward claimers file path:', REWARD_CLAIMERS_FILE);

const BUTTON_ADDRESS = '0x3DE5C1118bfecB5DE628FDE9b3e0c72FEE66b7f2' as Address;
console.log('Button contract address:', BUTTON_ADDRESS);

const RPC_URL = 'https://bepolia.rpc.berachain.com';
console.log('RPC URL:', RPC_URL);

// Initialize viem public client
const client = createPublicClient({
  chain: berachainBepolia,
  transport: http(RPC_URL),
});

// Create readline interface for user input
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Button contract ABI - defines the interface for interacting with the button contract
const BUTTON_ABI = [
  {
    inputs: [],
    name: "ButtonCooldownActive",
    type: "error"
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "presser",
        type: "address"
      }
    ],
    name: "ButtonPressed",
    type: "event"
  },
  {
    inputs: [],
    name: "COOLDOWN_PERIOD",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256"
      }
    ],
    stateMutability: "view",
    type: "function"
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address"
      }
    ],
    name: "lastPressTime",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256"
      }
    ],
    stateMutability: "view",
    type: "function"
  },
  {
    inputs: [],
    name: "pressButton",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function"
  }
] as const;

// Function to check if an address can press the button
// Returns true if the address has never pressed the button or if the cooldown period has passed
async function canPressButton(address: Address): Promise<boolean> {
  try {
    // Get the last time this address pressed the button
    const lastPressTime = await client.readContract({
      address: BUTTON_ADDRESS,
      abi: BUTTON_ABI,
      functionName: 'lastPressTime',
      args: [address]
    });

    // Get the cooldown period from the contract (in seconds)
    const cooldownPeriod = await client.readContract({
      address: BUTTON_ADDRESS,
      abi: BUTTON_ABI,
      functionName: 'COOLDOWN_PERIOD'
    });

    // Calculate time since last press in seconds
    const currentTime = Math.floor(Date.now() / 1000);
    const timeSinceLastPress = currentTime - Number(lastPressTime);
    
    // Log timing information for debugging
    console.log(`Address ${address} last pressed at ${new Date(Number(lastPressTime) * 1000).toISOString()}`);
    console.log(`Time since last press: ${timeSinceLastPress} seconds`);
    console.log(`Cooldown period: ${cooldownPeriod} seconds`);
    
    // Return true if enough time has passed since last press
    return timeSinceLastPress >= Number(cooldownPeriod);
  } catch (error) {
    console.error(`Error checking if ${address} can press button:`, error);
    return false;
  }
}

// Function to press the button for a given address
// Returns the transaction hash if successful
async function pressButton(address: Address, privateKey: string): Promise<string> {
  try {
    // Create a wallet client with the private key
    const walletClient = createWalletClient({
      account: address,
      transport: http(RPC_URL),
      chain: berachainBepolia,
    });

    // Send the press button transaction
    const hash = await walletClient.writeContract({
      address: BUTTON_ADDRESS,
      abi: BUTTON_ABI,
      functionName: 'pressButton',
      account: address,
    });

    return hash;
  } catch (error) {
    console.error(`Error pressing button for ${address}:`, error);
    throw error;
  }
}

// Function to ask user a yes/no question
function askQuestion(question: string): Promise<boolean> {
  return new Promise((resolve) => {
    rl.question(`${question} (y/n): `, (answer) => {
      resolve(answer.toLowerCase() === 'y');
    });
  });
}

// Main function to process button presses
async function processButtonPresses() {
  try {
    let claimers: { address: string; privateKey: string }[] = [];

    // Check if reward_claimers.json exists
    if (existsSync(REWARD_CLAIMERS_FILE)) {
      const data = readFileSync(REWARD_CLAIMERS_FILE, 'utf-8');
      const existingClaimers = JSON.parse(data) as { address: string; privateKey: string }[];
      
      if (existingClaimers.length > 0) {
        console.log(chalk.blue(`Found ${existingClaimers.length} existing claimers in reward_claimers.json`));
        const shouldLoad = await askQuestion('Do you want to load these addresses?');
        
        if (shouldLoad) {
          claimers = existingClaimers;
        } else {
          console.log(chalk.yellow('Warning: Old addresses will be lost. Creating new file...'));
          writeFileSync(REWARD_CLAIMERS_FILE, JSON.stringify([], null, 2));
          console.log(chalk.green('Created empty reward_claimers.json. Please add claimer addresses to the file.'));
          rl.close();
          return;
        }
      }
    } else {
      console.log(chalk.yellow('reward_claimers.json not found. Creating empty file...'));
      writeFileSync(REWARD_CLAIMERS_FILE, JSON.stringify([], null, 2));
      console.log(chalk.green('Created empty reward_claimers.json. Please add claimer addresses to the file.'));
      rl.close();
      return;
    }

    if (claimers.length === 0) {
      console.log(chalk.yellow('No claimers found in reward_claimers.json. Please add claimer addresses to the file.'));
      rl.close();
      return;
    }

    console.log(chalk.blue(`Processing ${claimers.length} claimers`));

    // Process each claimer
    for (const claimer of claimers) {
      const address = claimer.address as Address;
      const privateKey = claimer.privateKey;
      console.log(chalk.yellow(`\nProcessing claimer: ${address}`));

      try {
        const canPress = await canPressButton(address);
        if (canPress) {
          console.log(chalk.green('Can press button - pressing now'));
          const txHash = await pressButton(address, privateKey);
          console.log(`Successfully pressed button for ${address}. Tx hash: ${txHash}`);
        } else {
          console.log(chalk.red('Cannot press button - skipping'));
        }
      } catch (error) {
        console.error(chalk.red(`Error processing claimer ${address}:`), error);
      }
    }
  } catch (error) {
    console.error(chalk.red('Error in main process:'), error);
    process.exit(1);
  } finally {
    rl.close();
  }
}

// Run the script
processButtonPresses().catch((error) => {
  console.error(chalk.red('Fatal error:'), error);
  process.exit(1);
}); 