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

### Button
- **Address**: `0x3DE5C1118bfecB5DE628FDE9b3e0c72FEE66b7f2`
- **Contract**: [Button.sol](../contracts/src/examples/Button.sol)
- **Verification**: [View on Berascan](https://testnet.berascan.com/address/0x3de5c1118bfecb5de628fde9b3e0c72fee66b7f2)
- **Description**: Example button contract with cooldown functionality

## Deployment Details
- **Network**: Berachain Testnet (Bepolia)
- **RPC URL**: https://bepolia.rpc.berachain.com
- **Block Explorer**: https://testnet.berascan.com

## Contract Interactions
1. FBGT token ownership is transferred to the LiquidBGTMinter
2. LiquidBGTMinter is initialized with the FBGT token address
3. RewardVaultManagerMerkle manages the reward vaults and their tokens 