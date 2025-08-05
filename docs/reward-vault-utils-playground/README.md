# Reward Vault Utils Playground

This directory contains utilities and examples for working with Reward Vault contracts on Berachain Bepolia testnet.

## Contents

### Next.js Deployment Example
- **File**: `nextjs-deployment-example.md`
- **Description**: Complete guide for deploying `RewardVaultLootBox` directly from a Next.js application
- **Features**:
  - Direct contract deployment (no factory needed)
  - Parameter validation
  - React hooks for deployment
  - Wagmi configuration for Berachain
  - Complete ABI and component examples

### Contract Artifacts
- **RewardVaultLootBox.json**: Main contract ABI and bytecode for deployment
- **LootBox.json**: NFT contract artifacts
- **LootBoxFactory.json**: Factory contract artifacts (reference)
- **RewardVaultLootBoxFactory.json**: Factory contract artifacts (reference)

## Contract Addresses

### Berachain Bepolia Testnet
- **Entropy Contract**: `0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320`
- **Default Entropy Provider**: `0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344`
- **LootBoxFactory**: `0x6807ee246ee005fb984DBfCd2Fc484e043459Bb2`
- **RewardVaultLootBoxFactory**: `0x856Fe54612B1c6D4a4b992A9961D153d3bda1793`
A
## Quick Start

1. **For Next.js Deployment**: See `nextjs-deployment-example.md`
2. **For Foundry Deployment**: Use the scripts in `contracts/script/`

## Key Benefits

- **No Size Constraints**: Direct deployment bypasses factory contract size limits
- **Full Control**: Complete control over deployment parameters
- **Better UX**: Real-time feedback and progress tracking
- **Flexible**: Deploy multiple instances with different configurations

## Network Details

- **Network**: Berachain Bepolia Testnet
- **Chain ID**: 80069
- **RPC URL**: https://bepolia.rpc.berachain.com
- **Block Explorer**: https://bepolia.beratrail.io 