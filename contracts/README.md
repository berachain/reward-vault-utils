# Reward Vault Smart Contracts

A comprehensive collection of smart contracts, tools, and utilities for building reward distribution systems on Berachain.

## Overview

This repository provides a suite of tools for developers building reward distribution systems, with a focus on:
- Gas-efficient reward distribution
- Extensible reward vault management
- Merkle-based reward verification
- Example implementations
- Integration with Berachain's reward vault system

## Key Features

- **RewardVaultManager**: Base contract for reward management and distribution
- **Merkle-based Distribution**: Gas-efficient reward distribution using merkle proofs
- **Liquid BGT Integration**: Support for liquid BGT minting and distribution
- **Example Implementations**: Complete examples for common use cases
- **Comprehensive Testing**: Full test coverage for all contracts

## Alternative Distribution Methods

### Merkl Integration

Instead of using the built-in indexer, you can leverage [Merkl's Encompassing Campaigns](https://docs.merkl.xyz/merkl-mechanisms/campaign-types/encompassing) for reward distribution. This approach provides:

- **No Indexer Required**: Merkl handles the distribution infrastructure
- **API-Based Rewards**: Provide reward data via JSON endpoints
- **Automatic Processing**: Merkl processes rewards every 4-8 hours
- **Frontend Integration**: Built-in campaign visibility and claiming interface
- **Flexible Updates**: Dynamic reward updates throughout campaign duration

The reward vault contracts can be adapted to work with Merkl's distribution system by:
- Implementing Merkl-compatible reward endpoints
- Structuring reward data according to Merkl's JSON format
- Configuring campaigns with start/end dates and reward/data URLs

*Note: Merkl compatibility updates to the contracts will be implemented in future releases.*

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

For detailed documentation and guides, see the main [README.md](../README.md) and [docs/](../docs/) directory.

## Contributing

We welcome contributions! Please see our contributing guidelines for more information.

## License

MIT 