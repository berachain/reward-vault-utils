# Reward Vault Utilities

A toolkit for building reward systems on Berachain with loot boxes, merkle distributions, and real-time rewards.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Berachain](https://img.shields.io/badge/Built%20for-Berachain-blue)](https://berachain.com)

> ⚠️ **Experimental Software**: This project is in active development and has not been audited. Use at your own risk. Not recommended for production use without thorough security review.

## What's Here

This repo contains smart contracts and tools for creating reward systems on Berachain. We've built:

- **Loot Box System** - NFT-based rewards with Pyth entropy for randomness
- **Merkle Distributions** - Gas-efficient batch reward distribution  
- **Real-Time Rewards** - Instant reward distribution and claiming

Everything is deployed and tested on Berachain Bepolia testnet.

## Project Structure

```
competition-vault/
├── contracts/                 # Solidity contracts
│   ├── src/
│   │   ├── core/             # Base reward vault contracts
│   │   ├── examples/         # LootBox, FBGT, Button implementations
│   │   ├── interfaces/       # Contract interfaces
│   │   └── utilities/        # Factories and utilities
│   ├── script/               # Deployment scripts
│   └── test/                 # Contract tests
├── docs/                     # Documentation and guides
│   ├── deployments.md        # Deployed contract addresses
│   └── reward-vault-utils-playground/  # UI integration examples
└── indexer/                  # NestJS backend for indexing
```

## Quick Start

### Prerequisites
- Node.js 18+
- Foundry
- Berachain Bepolia testnet access

### Setup

```bash
# Clone and install
git clone https://github.com/berachain/reward-vault-utils.git
cd reward-vault-utils
pnpm install

# Install Foundry dependencies
cd contracts && forge install && cd ..
```

### Deploy Contracts

```bash
# Set environment
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

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/new-thing`)
3. Make your changes
4. Run tests: `cd contracts && forge test`
5. Commit with conventional commits: `git commit -m 'feat: add new thing'`
6. Push and open a PR

## License

MIT License - see [LICENSE](LICENSE) for details.

---

> ⚠️ **Disclaimer**: This software is provided "as is" without warranty of any kind. Use at your own risk. The authors are not responsible for any losses or damages resulting from the use of this software.
