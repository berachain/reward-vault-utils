# Deployed Contracts on Berachain Testnet

## Overview
This document contains the addresses and verification links for all contracts deployed on the Berachain testnet (Bepolia).

## Contract Addresses

### FBGT Token
- **Address**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece`
- **Contract**: [FBGT.sol](../contracts/src/examples/FBGT.sol)
- **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x4ed091c61ddb2b2dc69d057284791fed9d640ece)
- **Description**: ERC20 token contract for Fake BGT (FBGT)

### LiquidBGTMinter
- **Address**: `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681`
- **Contract**: [LiquidBGTMinter.sol](../contracts/src/examples/LiquidBGTMinter.sol)
- **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x0d91683c12313d0a35a95bb14a16bcaa208bf681)
- **Description**: Contract for minting liquid BGT tokens based on rewards
- **Constructor Args**: FBGT Token (`0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece`)

### RewardVaultManagerMerkle
- **Address**: `0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3`
- **Contract**: [RewardVaultManagerMerkle.sol](../contracts/src/examples/RewardVaultManagerMerkle.sol)
- **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x9f6a372c6f391fb1e1a7c078004bc489212bdea3)
- **Description**: Manager contract for reward vaults with merkle tree support

### Loot Box System (Latest Deployment)
- **LootBox NFT**: `0x891a2e459303DbEb5487a7f437142A70D5912dDe`
  - **Contract**: [LootBox.sol](../contracts/src/examples/LootBox.sol)
  - **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x891a2e459303dbeb5487a7f437142a70d5912dde)
  - **Description**: ERC-721 NFT contract for loot box tokens

- **RewardVaultLootBox**: `0x8A64bDB68F39238A724A9B7e5538fcC7F35a0465`
  - **Contract**: [RewardVaultLootBox.sol](../contracts/src/examples/RewardVaultLootBox.sol)
  - **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x8a64bdb68f39238a724a9b7e5538fcc7f35a0465)
  - **Description**: Main loot box system controller with liquid BGT integration
  - **Liquid BGT Token**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece` (FBGT)
  - **Pyth Entropy Provider**: `0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344`

### Button
- **Address**: `0x3DE5C1118bfecB5DE628FDE9b3e0c72FEE66b7f2`
- **Contract**: [Button.sol](../contracts/src/examples/Button.sol)
- **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x3de5c1118bfecb5de628fde9b3e0c72fee66b7f2)
- **Description**: Example button contract with cooldown functionality

### MerkleManagerFactory
- **Address**: `0x092E78918008b04C12FF05b5acD9D3b48597d9D1` (Latest)
- **Contract**: [MerkleManagerFactory.sol](../contracts/src/utilities/MerkleManagerFactory.sol)
- **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x092E78918008b04C12FF05b5acD9D3b48597d9D1)
- **Description**: Factory contract for deploying Merkle Reward Vault Manager contracts
- **Constructor Args**: RewardVaultFactory (`0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8`)

#### Test Deployment Results
The factory was successfully deployed and tested with the following deployed contracts:
- **Manager**: `0x9080f7c6c32FBD13B6811a762dF74332416Ca96B`
- **RewardVaultToken**: `0x690b12E847B89a2f6dEE8519A7AF9c10C5788a2B`
- **FBGT**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece` (existing)
- **LiquidBGTMinter**: `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681` (existing)

### Loot Box Factories (Latest Deployment)

#### LootBoxFactory
- **Address**: `0xB4B94796903761F8eA7AD3A9531ED54077e9a9D6` ✅ **DEPLOYED & VERIFIED**
- **Contract**: [LootBoxFactory.sol](../contracts/src/utilities/LootBoxFactory.sol)
- **Verification**: [View on Berascan](https://bepolia.beratrail.io/address/0xb4b94796903761f8ea7ad3a9531ed54077e9a9d6)
- **Transaction**: [0x9d0392d2690f4402a15e1a04516af6fc2f2ea45db36e2c4a04f1451ea615809e](https://testnet.berascan.com/tx/0x9d0392d2690f4402a15e1a04516af6fc2f2ea45db36e2c4a04f1451ea615809e)
- **Description**: Factory contract for deploying LootBox NFT contracts
- **Size**: 17,067 bytes ✅
- **Features**: 
  - Hardcoded entropy addresses for Berachain Bepolia
  - Transfers ownership to deployer
  - Simple interface with name, symbol, and baseURI parameters

#### RewardVaultLootBoxFactory
- **Address**: `0x76dDA2D109F3570EbaCac4a1271a38a1a5d52D9B` ✅ **DEPLOYED & VERIFIED**
- **Contract**: [RewardVaultLootBoxFactory.sol](../contracts/src/utilities/RewardVaultLootBoxFactory.sol)
- **Verification**: [View on Berascan](https://bepolia.beratrail.io/address/0x76dda2d109f3570ebacac4a1271a38a1a5d52d9b)
- **Transaction**: [0xebab8fdeb85c8a0f984d9677fddb795aee49d89315725bf92adbdad5bb65cffb](https://testnet.berascan.com/tx/0xebab8fdeb85c8a0f984d9677fddb795aee49d89315725bf92adbdad5bb65cffb)
- **Description**: Parameter factory for RewardVaultLootBox deployment
- **Size**: 2,547 bytes ✅ (ultra-lightweight)
- **Features**:
  - Hardcoded entropy addresses for Berachain Bepolia
  - Provides deployment parameters without importing the large RewardVaultLootBox contract
  - Enables UI to get correct parameters for manual deployment
  - Functions:
    - `getEntropyContract()`: Returns entropy contract address
    - `getDefaultEntropyProvider()`: Returns default provider address
    - `getDeploymentParams()`: Returns both addresses for deployment
    - `validateDeploymentParams()`: Validates rarity probabilities and rewards
    - `getConstructorArgs()`: Generates ABI-encoded constructor arguments

#### Test Deployment Results
The factories were successfully deployed and tested:
- **LootBoxFactory**: `0xB4B94796903761F8eA7AD3A9531ED54077e9a9D6` ✅
- **RewardVaultLootBoxFactory**: `0x76dDA2D109F3570EbaCac4a1271a38a1a5d52D9B` ✅
- **Test LootBox**: `0xD09586f3474182D1c2ff4DF967856D086A89DCCf` ✅
- **Entropy Contract**: `0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320`
- **Default Provider**: `0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344`

**Deployment Transaction**: [0x9d0392d2690f4402a15e1a04516af6fc2f2ea45db36e2c4a04f1451ea615809e](https://testnet.berascan.com/tx/0x9d0392d2690f4402a15e1a04516af6fc2f2ea45db36e2c4a04f1451ea615809e)
**Gas Used**: 7,333,781 gas (0.146675620051336467 ETH)

### FBGT Faucet (Latest Deployment)

#### FBGTFaucet
- **Address**: `0x2926F93c33D2198Be39aA90BFd06b857cdC8AB2D` ✅ **DEPLOYED & VERIFIED**
- **Contract**: [FBGTFaucet.sol](../contracts/src/utilities/FBGTFaucet.sol)
- **Verification**: [View on Berascan](https://bepolia.beratrail.io/address/0x2926f93c33d2198be39aa90bfd06b857cdc8ab2d)
- **Transaction**: [0x4e2fbc426506ca81025560e063a94fe128fefc12152306ecb79b43b0c3fd64ea](https://testnet.berascan.com/tx/0x4e2fbc426506ca81025560e063a94fe128fefc12152306ecb79b43b0c3fd64ea)
- **Description**: Simple faucet contract for distributing FBGT tokens
- **Size**: 5,432 bytes ✅
- **Features**:
  - Owner-only token distribution
  - Single and batch distribution functions
  - Token withdrawal capability
  - Balance checking functions
  - Hardcoded FBGT token address for Berachain Bepolia
- **Functions**:
  - `distributeTokens(address recipient, uint256 amount)`: Distribute tokens to single address
  - `distributeTokensBatch(address[] recipients, uint256[] amounts)`: Distribute tokens to multiple addresses
  - `withdrawTokens(uint256 amount)`: Withdraw tokens from faucet (owner only)
  - `getFaucetBalance()`: Get current FBGT balance
  - `getFBGTAddress()`: Get FBGT token address

**Deployment Transaction**: [0x4e2fbc426506ca81025560e063a94fe128fefc12152306ecb79b43b0c3fd64ea](https://testnet.berascan.com/tx/0x4e2fbc426506ca81025560e063a94fe128fefc12152306ecb79b43b0c3fd64ea)
**Gas Used**: 1,255,985 gas (0.050239400008791895 ETH)

## Deployment Details
- **Network**: Berachain Testnet (Bepolia)
- **RPC URL**: https://bepolia.rpc.berachain.com
- **Block Explorer**: https://testnet.berascan.com

## Contract Interactions
1. FBGT token ownership is transferred to the LiquidBGTMinter
2. LiquidBGTMinter is initialized with the FBGT token address
3. RewardVaultManagerMerkle manages the reward vaults and their tokens
4. **Loot Box System**: RewardVaultLootBox is configured with FBGT as the liquid BGT token for rewards
5. **Pyth Entropy Integration**: RewardVaultLootBox uses Pyth Entropy for provably fair randomness
6. **MerkleManagerFactory**: Automates deployment of Merkle Reward Vault Manager contracts with proper initialization and ownership transfer 