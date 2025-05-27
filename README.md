# Competition Vault

A decentralized competition rewards system integrated with Berachain's proof of liquidity mechanism. This project enables fair and transparent distribution of rewards based on user participation and liquidity provision.

## Overview

The Competition Vault system consists of two main components:

1. **Smart Contracts**: A set of Solidity contracts that handle competition logic, reward distribution, and integration with Berachain's proof of liquidity.
2. **Indexer**: A NestJS-based service that tracks competition events, maintains user statistics, and provides APIs for frontend integration.

## Key Features

- **Proof of Liquidity Integration**: Leverages Berachain's proof of liquidity mechanism to ensure fair reward distribution
- **Competition Management**: Create and manage competitions with customizable parameters
- **Reward Distribution**: Automated and transparent reward distribution based on participation and liquidity metrics
- **Event Indexing**: Real-time tracking of competition events and user interactions
- **API Integration**: RESTful APIs for frontend integration and data querying

## Project Structure

```
competition-vault/
├── contracts/         # Smart contracts for competition and reward logic
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