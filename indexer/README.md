# Competition Vault Indexer

This is the indexer service for the Competition Vault project. It listens to button press events from the smart contract and maintains a database of all button presses. It also generates merkle trees for reward distribution.

## Features

- Real-time indexing of button press events
- PostgreSQL database for storing button press data
- Merkle tree generation for reward distribution
- Time-window based querying of button press data

## Prerequisites

- Node.js (v18 or later)
- PostgreSQL
- Access to Berachain RPC endpoint

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. Set up the database:
   ```bash
   npx prisma migrate dev
   ```

4. Start the development server:
   ```bash
   npm run start:dev
   ```

## Database Schema

The indexer uses two main tables:

1. `ButtonPress`: Stores all button press events
   - `id`: Unique identifier
   - `address`: EVM address of the presser
   - `timestamp`: When the button was pressed
   - `blockNumber`: Block number of the press
   - `txHash`: Transaction hash

2. `RewardDistribution`: Stores merkle tree data for reward distribution
   - `id`: Unique identifier
   - `startTime`: Start of the reward period
   - `endTime`: End of the reward period
   - `totalRewards`: Total rewards to distribute
   - `merkleRoot`: Root of the merkle tree
   - `merkleProofs`: JSON object containing proofs for each address

## API Endpoints

The indexer provides the following functionality:

1. Get button presses in a time window
2. Get button press counts by address
3. Generate merkle tree for reward distribution

## Development

- Run tests: `npm test`
- Generate Prisma client: `npx prisma generate`
- View database: `npx prisma studio`

## License

MIT 