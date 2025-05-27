# Competition Vault Indexer

A NestJS-based service that tracks competition events, maintains user statistics, and provides APIs for frontend integration.

## Overview

The indexer service:
- Tracks competition events from the blockchain
- Maintains a database of user participation
- Generates merkle trees for reward distribution
- Provides RESTful APIs for frontend integration

## Features

- Real-time event indexing
- PostgreSQL database with Prisma ORM
- RESTful API endpoints
- Docker support for easy deployment
- Integration with Berachain's proof of liquidity

## Development Setup

### Prerequisites

- Node.js (v18 or later)
- pnpm
- PostgreSQL (or Docker)
- Docker and Docker Compose (optional)

### Installation

```bash
# Install dependencies
pnpm install

# Copy environment file
cp .env.example .env

# Generate Prisma client
pnpm prisma generate

# Run database migrations
pnpm prisma migrate dev
```

### Running the Service

```bash
# Development mode
pnpm start:dev

# Production mode
pnpm build
pnpm start:prod
```

### Docker Setup

```bash
# Build and start services
docker compose up --build

# View logs
docker compose logs -f
```

## API Endpoints

### Competition Endpoints

- `GET /competitions`: List all competitions
- `GET /competitions/:id`: Get competition details
- `POST /competitions`: Create new competition

### User Endpoints

- `GET /users/:address`: Get user statistics
- `GET /users/:address/participations`: Get user's competition participations

### Reward Endpoints

- `GET /rewards/:competitionId`: Get competition rewards
- `POST /rewards/:competitionId/claim`: Claim rewards

## Database Schema

The indexer uses Prisma with PostgreSQL. Key models include:

- `Competition`: Competition details and parameters
- `ButtonPress`: User participation records
- `Reward`: Reward distribution records

## Testing

```bash
# Unit tests
pnpm test

# E2E tests
pnpm test:e2e

# Test coverage
pnpm test:cov
```

## License

MIT 