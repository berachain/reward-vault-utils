# Reward Vault Utilities

A comprehensive suite of tools and utilities for building reward distribution systems on Berachain. This project provides extensible base contracts and example implementations for various reward distribution strategies.

## Overview

The Reward Vault Utilities system consists of two main components:

1. **Smart Contracts**: A collection of base contracts and example implementations for reward distribution, including:
   - Extensible reward vault manager base contract
   - Merkle-based distribution implementation
   - **Loot Box System**: Pyth Entropy-powered NFT loot boxes with provably fair randomness
   - Example implementations for various use cases
2. **Indexer**: A NestJS-based service that provides event tracking, merkle tree management, and APIs for frontend integration.

## Architecture

The system is built around an extensible reward vault manager that can be customized for different distribution strategies:

1. **Base Reward Vault Manager**: Provides core functionality for reward management and distribution
2. **Merkle Implementation**: Example extension that uses merkle proofs for gas-efficient distribution
3. **Loot Box System**: NFT-based loot boxes using Pyth Entropy for provably fair randomness
4. **Custom Extensions**: Developers can create their own extensions for specific distribution needs

## 🎁 Loot Box System - Successfully Deployed!

The Loot Box System has been successfully deployed and tested on Berachain Bepolia testnet!

### ✅ First Successful Transaction
- **Transaction Hash**: `0x6b89557c7505aafa27789d90025d06e79542b7623427510fa2a4746952155ff1`
- **Status**: ✅ Successfully minted first loot box NFT
- **View on Berascan**: [Transaction Details](https://testnet.berascan.com/tx/0x6b89557c7505aafa27789d90025d06e79542b7623427510fa2a4746952155ff1)

### 🏗️ Deployed Contracts
- **LootBox NFT**: `0xBfE1657Fd43d18fF5023d34a8E5E9218aD040d8B`
- **RewardVaultLootBox**: `0xce63Ae8857C5608DbbD7089D873Dd681375db714`

### 📚 Documentation
- [Loot Box System Guide](./docs/lootbox-system.md)
- [Successful Transactions](./docs/successful-transactions.md)

## Project Structure

```
reward-vault-utils/
├── contracts/         # Smart contracts for reward distribution
│   ├── src/
│   │   ├── core/     # Base reward vault manager and core contracts
│   │   ├── merkle/   # Merkle-based distribution implementation
│   │   └── examples/ # Example implementations and usage
│   │       ├── LootBox.sol              # ERC-721 NFT contract
│   │       ├── RewardVaultLootBox.sol   # Main loot box controller
│   │       └── ...                      # Other examples
├── docs/             # Documentation
│   ├── lootbox-system.md           # Loot box system documentation
│   └── successful-transactions.md  # Transaction history
└── indexer/          # NestJS service for event indexing and API endpoints
```

## Getting Started

See the individual README files in each directory for specific setup instructions:

- [Contracts Setup](./contracts/README.md)
- [Indexer Setup](./indexer/README.md)
- [Loot Box System Documentation](./docs/lootbox-system.md)

## Development

1. Clone the repository
2. Install dependencies for both contracts and indexer
3. Follow the setup instructions in each component's README
4. Run tests to ensure everything is working correctly

## License

MIT 