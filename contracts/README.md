# Competition Vault Contracts

This directory contains the Solidity smart contracts for the Competition Vault project, designed to integrate with Berachain's Bepolia network.

## Overview

The contracts are built using Forge and include the following components:

- **CompetitionManagerMerkle**: Manages the competition logic and integrates with the reward vault.
- **Button**: A simple contract for testing and demonstration purposes.
- **Interfaces**: Local interfaces for external contracts, such as `IRewardVault`, to ensure compatibility with Berachain's contracts.

## Dependencies

- **Solmate**: The only external dependency used in the project. All other dependencies (OpenZeppelin, Berachain contracts) have been removed to simplify the build process.

## Deployment

The deployment script (`Deploy.s.sol`) automates the deployment of the `CompetitionManagerMerkle` and `Button` contracts. It also logs the addresses of the deployed contracts for easy reference.

## Testing

The test suite includes tests for the `Button` and `CompetitionManagerMerkle` contracts. The tests are designed to ensure that the contracts function as expected and integrate correctly with the reward vault.

## Integration with Berachain

The contracts are designed to work with Berachain's Bepolia network. The `CompetitionManagerMerkle` contract is initialized with a reward vault, which is created using the `RewardVaultFactory` provided by Berachain.

## Next Steps

- Further integration with Berachain's network.
- Additional testing and validation of the contracts.
- Deployment to the mainnet or testnet as needed.

# Contracts Project

This directory contains the smart contracts for the competition system, managed as a standalone Foundry (Forge) project.

## Setup & Dependency Management

- Dependencies are managed using Forge's built-in system (not git submodules).
- All dependencies are installed into the `lib/` directory using `forge install`.
- The Berachain contracts and other libraries are referenced in `remappings.txt`.

### Install Dependencies
```sh
forge install https://github.com/berachain/contracts.git
forge install https://github.com/OpenZeppelin/openzeppelin-contracts.git
forge install https://github.com/foundry-rs/forge-std.git
forge install https://github.com/transmissions11/solmate.git
forge install https://github.com/Vectorized/solady.git
```

### Build Contracts
```sh
forge build
```

### Run Tests
```sh
forge test
```

## Project Structure
- `src/` — Solidity contract sources
- `test/` — Forge test files
- `script/` — Deployment scripts
- `lib/` — Solidity dependencies (managed by Forge)

## Notes
- Do **not** manually add or commit dependencies in `lib/` to git. Use `forge install` to manage them.
- If you need to update a dependency, re-run `forge install` with the appropriate URL.
- Remappings are managed in `remappings.txt`.

# Competition Vault

A decentralized competition system built on Berachain that allows users to participate in button-pressing competitions and earn rewards.

## Project Structure

```
competition-vault/
├── contracts/              # Smart contracts
│   ├── src/               # Contract source files
│   │   ├── ButtonPressCompetition.sol
│   │   ├── CompetitionRewardVault.sol
│   │   └── CompetitionToken.sol
│   └── test/              # Contract tests
├── indexer/               # NestJS-based indexer service
│   ├── src/              # Indexer source code
│   └── prisma/           # Database schema and migrations
├── bot/                   # Bot service
├── docker/               # Docker configurations
├── shared/               # Shared utilities
└── script/               # Deployment scripts
```

## Smart Contracts

### ButtonPressCompetition
A simple competition contract where users can press a button and earn rewards based on their participation. The competition periods are managed off-chain, with the contract only tracking button presses.

### CompetitionRewardVault
Manages the distribution of rewards to competition participants using a merkle tree for efficient verification.

### CompetitionToken
The token used for competition participation and rewards.

## Development

### Prerequisites
- Foundry
- Node.js
- Docker (optional)

### Setup

1. Install dependencies:
```bash
# Install Foundry dependencies
forge install

# Install indexer dependencies
cd indexer
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env
# Fill in the required environment variables
```

3. Run tests:
```bash
# Run contract tests
forge test

# Run indexer tests
cd indexer
npm test
```

## Deployment

1. Deploy contracts:
```bash
forge script script/Deploy.s.sol:Deploy --rpc-url $BERACHAIN_RPC_URL --broadcast
```

2. Start the indexer:
```bash
cd indexer
npm run start:dev
```

## Architecture

The system consists of three main components:

1. **Smart Contracts**: Handle the core competition logic and reward distribution
2. **Indexer**: Tracks competition events and manages reward distribution
3. **Bot**: Monitors the blockchain and triggers competition periods

## License

MIT 