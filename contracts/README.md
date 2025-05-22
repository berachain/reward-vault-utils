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
├── lib/                  # Dependencies
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