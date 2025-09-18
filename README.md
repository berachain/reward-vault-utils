# Reward Vault Utilities

Smart contracts and tools for building reward distribution systems on Berachain.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Warning**: This software is experimental and unaudited. Use at your own risk.

## Components

This repository contains:

- **Loot Box System** - NFT-based rewards with Pyth entropy for randomness
- **Merkle Distributions** - Gas-efficient batch reward distribution  
- **Real-Time Rewards** - Instant reward distribution and claiming

All contracts are deployed and tested on Berachain Bepolia testnet.

## Project Structure

```
reward-vault-utils/
├── contracts/                 # Solidity contracts
│   ├── src/
│   │   ├── core/             # Core reward vault contracts
│   │   ├── examples/         # Example implementations
│   │   ├── interfaces/       # Contract interfaces
│   │   └── utilities/        # Factory contracts
│   ├── script/               # Deployment scripts
│   └── test/                 # Contract tests
└── docs/                     # Documentation
    ├── deployments.md        # Contract addresses
    └── reward-vault-utils-playground/  # Integration examples
```

## Quick Start

### Prerequisites
- Foundry
- Berachain Bepolia testnet access

### Setup

```bash
# Clone repository
git clone https://github.com/berachain/reward-vault-utils.git
cd reward-vault-utils

# Install Foundry dependencies
cd contracts && forge install && cd ..
```

### Deploy Contracts

```bash
# Set environment variables
cp .env.example .env
# Add your private key and RPC URL

# Deploy loot box system
forge script contracts/script/DeployLootBox.s.sol --rpc-url $RPC_URL --broadcast
```

## Deployed Contracts

All contracts are deployed on Berachain Bepolia testnet:

- **FBGT Token**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece`
- **LiquidBGTMinter**: `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681`
- **LootBoxFactory**: `0xB4B94796903761F8eA7AD3A9531ED54077e9a9D6`
- **RewardVaultLootBoxFactory**: `0x76dDA2D109F3570EbaCac4a1271a38a1a5d52D9B`
- **FBGTFaucet**: `0x2926F93c33D2198Be39aA90BFd06b857cdC8AB2D`

See [deployments.md](docs/deployments.md) for full details and verification links.

## Development

### Running Tests

```bash
cd contracts
forge test -vv
```

### Building Contracts

```bash
cd contracts
forge build
```

## Documentation

- [Deployment Guide](docs/deployments.md) - Contract addresses and verification
- [Loot Box System](docs/lootbox-system.md) - How the loot box system works
- [UI Integration](docs/reward-vault-utils-playground/) - Next.js deployment examples

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `cd contracts && forge test`
5. Commit with conventional commits
6. Push and open a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.
