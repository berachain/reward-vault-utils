# Reward Vault Smart Contracts

A comprehensive collection of smart contracts, tools, and utilities for building reward distribution systems on Berachain.

## Overview

This repository provides a suite of tools for developers building reward distribution systems, with a focus on:
- Gas-efficient reward distribution
- Extensible reward vault management
- Merkle-based reward verification
- Example implementations
- Integration with Berachain's reward vault system

## Directory Structure

### Core Contracts (`src/core/`)
Core contracts that form the foundation of the reward vault system:
- `RewardVaultManager`: Base contract for reward management and distribution
- Provides core functionality for reward tracking, allocation, and distribution

### Merkle-based Distribution (`src/merkle/`)
Contracts implementing gas-efficient reward distribution using merkle proofs:
- `RewardVaultManagerMerkle`: Extends RewardVaultManager with merkle-based distribution
- Features merkle tree verification, gas-efficient claims, and reward allocation

### Interfaces (`src/interfaces/`)
Standard interfaces for system integration:
- `IRewardVault`: Interface for reward vault functionality (staking, distribution, claiming)
- `IRewardVaultFactory`: Interface for reward vault deployment and configuration

### Examples (`src/examples/`)
Example contracts and implementations:
- `FBGT`: Example ERC20 token implementation
- `LiquidBGTMinter`: Example implementation for liquid BGT minting

## Getting Started

1. Install dependencies:
```bash
forge install
```

2. Build the contracts:
```bash
forge build
```

3. Run tests:
```bash
forge test
```

## Documentation

The documentation website (coming soon) will provide comprehensive guides and examples for each component.

## Contributing

We welcome contributions! Please see our contributing guidelines for more information.

## License

MIT 