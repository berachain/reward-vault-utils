# Reward Vault Utilities

A comprehensive suite of tools and utilities for building reward distribution systems on Berachain. This project provides extensible base contracts and example implementations for various reward distribution strategies.

## Overview

The Reward Vault Utilities system consists of two main components:

1. **Smart Contracts**: A collection of base contracts and example implementations for reward distribution, including:
   - Extensible reward vault manager base contract
   - Merkle-based distribution implementation
   - Example implementations for various use cases
2. **Indexer**: A NestJS-based service that provides event tracking, merkle tree management, and APIs for frontend integration.

## Architecture

The system is built around an extensible reward vault manager that can be customized for different distribution strategies:

1. **Base Reward Vault Manager**: Provides core functionality for reward management and distribution
2. **Merkle Implementation**: Example extension that uses merkle proofs for gas-efficient distribution
3. **Custom Extensions**: Developers can create their own extensions for specific distribution needs

## Project Structure

```
reward-vault-utils/
├── contracts/         # Smart contracts for reward distribution
│   ├── src/
│   │   ├── core/     # Base reward vault manager and core contracts
│   │   ├── merkle/   # Merkle-based distribution implementation
│   │   └── examples/ # Example implementations and usage
└── indexer/          # NestJS service for event indexing and API endpoints
```

## Getting Started

See the individual README files in each directory for specific setup instructions:

- [Contracts Setup](./contracts/README.md)
- [Indexer Setup](./indexer/README.md)

## Development

1. Clone the repository
2. Install dependencies for both contracts and indexer
3. Follow the setup instructions in each component's README
4. Run tests to ensure everything is working correctly

## License

MIT 