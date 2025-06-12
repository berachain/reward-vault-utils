import 'dotenv/config';
import { createPublicClient, http, createWalletClient } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import type { Address } from 'viem';
import { berachainBepolia } from 'viem/chains';
import { readFileSync, existsSync, writeFileSync } from 'fs';
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

const __dirname = process.cwd();
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
    const account = privateKeyToAccount(privateKey as `0x${string}`);
    const walletClient = createWalletClient({
      account,
      transport: http(RPC_URL),
      chain: berachainBepolia,
    });

    // Send the press button transaction
    const hash = await walletClient.writeContract({
      address: BUTTON_ADDRESS,
      abi: BUTTON_ABI,
      functionName: 'pressButton',
      chain: berachainBepolia,
      account,
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
      const existingClaimers = JSON.parse(readFileSync(REWARD_CLAIMERS_FILE, 'utf-8'));
      console.log(`Found ${existingClaimers.length} existing claimers in reward_claimers.json`);
      
      const loadExisting = await askQuestion('Do you want to load these addresses?');
      if (loadExisting) {
        claimers = existingClaimers;
      }
    }

    if (claimers.length === 0) {
      console.log('No claimers loaded. Please add addresses to reward_claimers.json');
      return;
    }

    console.log(`Processing ${claimers.length} claimers\n`);

    for (const claimer of claimers) {
      console.log(`\nProcessing claimer: ${claimer.address}`);
      
      try {
        const canPress = await canPressButton(claimer.address as Address);
        
        if (canPress) {
          console.log('Can press button - pressing now');
          const txHash = await pressButton(claimer.address as Address, claimer.privateKey);
          console.log(chalk.green(`Successfully pressed button for ${claimer.address}. Tx hash: ${txHash}`));
        } else {
          console.log(chalk.yellow(`Cannot press button for ${claimer.address} - cooldown period not elapsed`));
        }
      } catch (error) {
        console.error(chalk.red(`Error processing ${claimer.address}:`), error);
      }
    }
  } catch (error) {
    console.error('Error in processButtonPresses:', error);
  } finally {
    rl.close();
  }
}

// Run the script
processButtonPresses().catch(console.error); 