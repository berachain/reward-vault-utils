# Reward Vault Utilities

> **The Ultimate Toolkit for Building Scalable Reward Systems on Berachain**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Berachain](https://img.shields.io/badge/Built%20for-Berachain-blue)](https://berachain.com)
[![Solidity](https://img.shields.io/badge/Solidity-^0.8.19-363636?logo=solidity)](https://soliditylang.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue?logo=typescript)](https://www.typescriptlang.org)

## Overview

**Reward Vault Utilities** is an experimental framework for building sophisticated reward distribution systems on Berachain. Whether you're launching a DeFi protocol, gaming platform, or community rewards program, our modular architecture provides everything you need to create engaging, fair, and scalable reward experiences.

> ⚠️ **Experimental Software**: This project is in active development and has not been audited. Use at your own risk. Not recommended for production use without thorough security review.

### Why Choose Reward Vault Utilities?

- **Provably Fair**: Built on Pyth Entropy for cryptographically secure randomness
- **Gas Optimized**: Merkle-based distributions for maximum efficiency
- **NFT-Powered**: Seamless integration with ERC-721 loot boxes and collectibles
- **Experimental**: Active development with testnet deployment
- **Extensible**: Modular design for custom reward strategies


## Core Features

### **Loot Box System** 
*Live on Berachain Bepolia Testnet*

Experience the future of NFT-based rewards with our Pyth Entropy-powered loot box system:

- **Provably Fair Randomness**: Every loot box opening is cryptographically verifiable
- **Multi-Tier Rarities**: 5-tier system with dynamic reward scaling
- **Liquid BGT Integration**: Seamless token distribution and claiming
- **Gas-Efficient**: Optimized for cost-effective mass distribution

### **Merkle-Based Distribution**
*Enterprise-grade reward management*

- **Batch Processing**: Distribute rewards to thousands of users in a single transaction
- **Proof Verification**: Cryptographic proofs ensure only eligible users can claim
- **Cost Optimization**: Dramatically reduce gas costs for large distributions
- **Flexible Allocation**: Support for multiple tokens and reward types



## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend Applications                    │
├─────────────────────────────────────────────────────────────┤
│                    API Layer (NestJS)                      │
├─────────────────────────────────────────────────────────────┤
│                Smart Contract Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   LootBox   │  │   Merkle    │  │   Custom    │        │
│  │   System    │  │ Distribution│  │ Extensions  │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
├─────────────────────────────────────────────────────────────┤
│                Berachain Blockchain                        │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

> ⚠️ **Security Notice**: This software is experimental and unaudited. Only use on testnets for development and testing purposes. Do not deploy to mainnet without comprehensive security audits.

### Prerequisites
- Node.js 18+
- Foundry
- Berachain Bepolia testnet access

### Installation

```bash
# Clone the repository
git clone https://github.com/berachain/reward-vault-utils.git
cd reward-vault-utils

# Install dependencies
pnpm install
cd contracts && forge install && cd ..
```

### Deploy Your First Loot Box System

```bash
# Set up environment
cp .env.example .env
# Add your private key and RPC URL

# Deploy contracts
forge script contracts/script/DeployLootBox.s.sol --rpc-url $RPC_URL --broadcast
```

## Documentation

- **[Loot Box System Guide](./docs/lootbox-system.md)** - Complete loot box implementation guide
- **[Deployment Guide](./docs/deployments.md)** - Contract addresses and verification links
- **[Transaction History](./docs/successful-transactions.md)** - Live deployment tracking

## Development

### Project Structure
```
reward-vault-utils/
├── contracts/                 # Smart contracts
│   ├── src/
│   │   ├── core/             # Base contracts
│   │   ├── examples/         # Implementation examples
│   │   └── interfaces/       # Contract interfaces
│   └── script/               # Deployment scripts

└── docs/                     # Documentation
```

### Testing
```bash
# Run contract tests
cd contracts && forge test -vv
```

## Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

> ⚠️ **Development Status**: This project is actively being developed and improved. APIs and contracts may change between versions. Please review the latest documentation before integrating.

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes using [conventional commits](https://www.conventionalcommits.org/):
   ```bash
   git commit -m 'feat: add amazing feature'
   git commit -m 'fix: resolve critical bug'
   git commit -m 'docs: update installation guide'
   ```
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ for the Berachain ecosystem**

> ⚠️ **Disclaimer**: This software is provided "as is" without warranty of any kind. Use at your own risk. The authors are not responsible for any losses or damages resulting from the use of this software.
