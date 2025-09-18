/**
 * LootBox and RewardVaultLootBox Deployment Script
 * 
 * This script dynamically loads contract artifacts from Foundry compilation output
 * and deploys LootBox and RewardVaultLootBox contracts to Berachain Bepolia testnet.
 * 
 * ## Artifact Loading System
 * 
 * The script loads both ABI and bytecode from Foundry's compilation artifacts located at:
 * - `/home/jintao/Documents/berachain/competition-vault/contracts/out/LootBox.sol/LootBox.json` - Contains LootBox ABI and bytecode
 * - `/home/jintao/Documents/berachain/competition-vault/contracts/out/RewardVaultLootBox.sol/RewardVaultLootBox.json` - Contains RewardVaultLootBox ABI and bytecode
 * 
 * Foundry artifacts contain:
 * - `artifact.abi` - The contract's ABI (function signatures, events, etc.)
 * - `artifact.bytecode` - The compiled bytecode (with 0x prefix)
 * 
 * ## Usage in Other Projects
 * 
 * To use this deployment system in another project:
 * 
 * 1. Copy the Foundry artifacts to your project:
 *    ```bash
 *    cp /home/jintao/Documents/berachain/competition-vault/contracts/out/LootBox.sol/LootBox.json /path/to/your/project/
 *    cp /home/jintao/Documents/berachain/competition-vault/contracts/out/RewardVaultLootBox.sol/RewardVaultLootBox.json /path/to/your/project/
 *    ```
 * 
 * 2. Copy the artifact loading functions:
 *    ```javascript
 *    function loadContractBytecode(contractName) {
 *      const artifact = JSON.parse(fs.readFileSync(`${contractName}.json`, 'utf8'));
 *      const bc = artifact.bytecode?.object || artifact.bytecode;
 *      if (!bc) throw new Error(`No bytecode in ${contractName}.json`);
 *      return bc.startsWith('0x') ? bc : `0x${bc}`;
 *    }
 *    
 *    function loadContractABI(contractName) {
 *      const artifact = JSON.parse(fs.readFileSync(`${contractName}.json`, 'utf8'));
 *      const abi = artifact.abi;
 *      if (!abi) throw new Error(`No ABI in ${contractName}.json`);
 *      return abi;
 *    }
 *    ```
 * 
 * 3. Use `walletClient.deployContract()` for deployments:
 *    ```javascript
 *    const hash = await walletClient.deployContract({
 *      abi: LOOTBOX_ABI,
 *      bytecode: LOOTBOX_BYTECODE,
 *      args: [name, symbol, baseURI],
 *      account: ACCOUNT,
 *    });
 *    ```
 * 
 * ## Key Features
 * - Dynamic artifact loading from Foundry compilation output
 * - Proper 0x prefix handling for bytecode
 * - Uses viem's `deployContract()` for automatic constructor encoding
 * - Supports Berachain Bepolia testnet
 * - Comprehensive error handling and logging
 */

const { createWalletClient, createPublicClient, http, parseEther, encodeFunctionData, getContract } = require('viem');
const { privateKeyToAccount } = require('viem/accounts');
const fs = require('fs');
const path = require('path');

// Import Berachain Bepolia from viem
const { berachainBepolia } = require('viem/chains');

// Configuration
const PRIVATE_KEY = '0x6a290278495134b4a5fe7de6bf586265704c24e07ac9f92dcf045e31dcea66a1';
const ACCOUNT = privateKeyToAccount(PRIVATE_KEY);

// Bepolia addresses from the original script
const REWARD_VAULT_FACTORY = '0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8';
const LIQUID_BGT_MINTER = '0x0d91683c12313d0a35A95Bb14a16bCAa208bf681';
const FBGT_TOKEN = '0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece';
const ENTROPY_CONTRACT = '0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320';
const DEFAULT_PROVIDER = '0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344';

// Utility function to load bytecode from Foundry artifacts
function loadContractBytecode(contractName) {
  try {
    const outPath = path.join(__dirname, 'contracts', 'out', `${contractName}.sol`, `${contractName}.json`);
    
    if (fs.existsSync(outPath)) {
      const artifact = JSON.parse(fs.readFileSync(outPath, 'utf8'));
      // Foundry format: artifact.bytecode or artifact.bytecode.object
      const bc = artifact.bytecode?.object || artifact.bytecode;
      if (!bc) throw new Error(`No bytecode in ${outPath}`);
      
      const bytecode = bc.startsWith('0x') ? bc : `0x${bc}`;
      console.log(`[INFO] Loaded bytecode for ${contractName} from Foundry artifacts`);
      return bytecode;
    }
    
    throw new Error(`Could not find bytecode for ${contractName}`);
  } catch (error) {
    console.error(`[ERROR] Failed to load bytecode for ${contractName}:`, error.message);
    throw error;
  }
}

// Utility function to load ABI from Foundry artifacts
function loadContractABI(contractName) {
  try {
    const outPath = path.join(__dirname, 'contracts', 'out', `${contractName}.sol`, `${contractName}.json`);
    
    if (fs.existsSync(outPath)) {
      const artifact = JSON.parse(fs.readFileSync(outPath, 'utf8'));
      const abi = artifact.abi;
      if (!abi) throw new Error(`No ABI in ${outPath}`);
      
      console.log(`[INFO] Loaded ABI for ${contractName} from Foundry artifacts`);
      return abi;
    }
    
    throw new Error(`Could not find ABI for ${contractName}`);
  } catch (error) {
    console.error(`[ERROR] Failed to load ABI for ${contractName}:`, error.message);
    throw error;
  }
}

// Contract ABIs (dynamically loaded)
let LOOTBOX_ABI;
let REWARD_VAULT_LOOTBOX_ABI;

// Contract bytecode (dynamically loaded)
let LOOTBOX_BYTECODE;
let REWARD_VAULT_LOOTBOX_BYTECODE;

// Create clients with explicit RPC URL
const RPC_URL = 'https://bepolia.rpc.berachain.com';
const publicClient = createPublicClient({
  chain: berachainBepolia,
  transport: http(RPC_URL)
});

const walletClient = createWalletClient({
  account: ACCOUNT,
  chain: berachainBepolia,
  transport: http(RPC_URL)
});

async function loadContractArtifacts() {
  console.log('=== Loading Contract Artifacts ===');
  
  try {
    // Load ABIs
    LOOTBOX_ABI = loadContractABI('LootBox');
    REWARD_VAULT_LOOTBOX_ABI = loadContractABI('RewardVaultLootBox');
    
    // Load bytecode
    LOOTBOX_BYTECODE = loadContractBytecode('LootBox');
    REWARD_VAULT_LOOTBOX_BYTECODE = loadContractBytecode('RewardVaultLootBox');
    
    console.log('[SUCCESS] All contract artifacts loaded successfully');
  } catch (error) {
    console.error('[ERROR] Failed to load contract artifacts:', error.message);
    throw error;
  }
}

async function deployContracts() {
  console.log('=== Deploying LootBox System ===');
  console.log('Deployer address:', ACCOUNT.address);

  try {
    // Load contract artifacts first
    await loadContractArtifacts();

    // 1. Deploy LootBox
    console.log('\n1. Deploying LootBox...');
    const lootBoxName = 'LootBox';
    const lootBoxSymbol = 'LOOT';
    const baseURI = 'https://example.com/metadata/';

    // Deploy LootBox using walletClient.deployContract
    const lootBoxHash = await walletClient.deployContract({
      abi: LOOTBOX_ABI,
      bytecode: LOOTBOX_BYTECODE,
      args: [lootBoxName, lootBoxSymbol, baseURI],
      account: ACCOUNT,
    });

    const lootBoxReceipt = await publicClient.waitForTransactionReceipt({ hash: lootBoxHash });
    const lootBoxAddress = lootBoxReceipt.contractAddress;
    console.log('[SUCCESS] LootBox deployed at:', lootBoxAddress);

    // 2. Deploy RewardVaultLootBox
    console.log('\n2. Deploying RewardVaultLootBox...');
    
    // Rarity probabilities: 50%, 40%, 9%, 0.9%, 0.1% (in bips)
    const rarityProbabilities = [5000, 4000, 900, 90, 10];
    
    // Reward bips for each rarity
    const rarityRewardBips = [10, 100, 500, 2000, 5000];

    // Deploy RewardVaultLootBox using walletClient.deployContract
    const rewardVaultLootBoxHash = await walletClient.deployContract({
      abi: REWARD_VAULT_LOOTBOX_ABI,
      bytecode: REWARD_VAULT_LOOTBOX_BYTECODE,
      args: [ENTROPY_CONTRACT, lootBoxAddress, DEFAULT_PROVIDER, rarityProbabilities, rarityRewardBips],
      account: ACCOUNT,
    });

    const rewardVaultLootBoxReceipt = await publicClient.waitForTransactionReceipt({ hash: rewardVaultLootBoxHash });
    const rewardVaultLootBoxAddress = rewardVaultLootBoxReceipt.contractAddress;
    console.log('[SUCCESS] RewardVaultLootBox deployed at:', rewardVaultLootBoxAddress);

    console.log('\n=== Deployment Summary ===');
    console.log('LootBox deployed at:', lootBoxAddress);
    console.log('RewardVaultLootBox deployed at:', rewardVaultLootBoxAddress);
    console.log('Deployer address:', ACCOUNT.address);
    console.log('Deployment completed successfully!');
    console.log('\nDeployment info saved to deployment-info.json');

  } catch (error) {
    console.error('Deployment failed:', error);
    throw error;
  }
}

// Run the deployment
deployContracts().catch(console.error);
