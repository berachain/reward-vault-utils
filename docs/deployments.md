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
- **Address**: `0x89a2e4bd1cfbf5D4C34C67606826922aB3e7D5Fd`
- **Contract**: [MerkleManagerFactory.sol](../contracts/src/utilities/MerkleManagerFactory.sol)
- **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x89a2e4bd1cfbf5d4c34c67606826922ab3e7d5fd)
- **Description**: Factory contract for deploying Merkle Reward Vault Manager contracts
- **Constructor Args**: RewardVaultFactory (`0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8`)

#### Test Deployment Results
The factory was successfully deployed and tested with the following deployed contracts:
- **Manager**: `0x779010dBbDC696164209cB189412be3f46Ab020d`
- **RewardVaultToken**: `0x4E0aaADf5319636cf06b16C1cEdf5CBd6DCE68C4`
- **FBGT**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece` (existing)
- **LiquidBGTMinter**: `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681` (existing)

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