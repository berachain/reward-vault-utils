# Reward Vault Indexer

A NestJS-based service that provides event tracking, merkle tree management, and APIs for reward distribution systems.

## Overview

The indexer service:
- Tracks reward vault events from the blockchain
- Manages merkle tree generation and verification
- Maintains a database of reward allocations and claims
- Provides RESTful APIs for frontend integration

## Features

- Real-time event indexing
- PostgreSQL database with Prisma ORM
- Merkle tree generation and verification
- RESTful API endpoints with Swagger documentation
- Docker support for easy deployment
- Integration with Berachain's reward vault system

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

## API Documentation

The API is documented using Swagger UI. Once the service is running, you can access the API documentation at:

```
http://localhost:3000/api
```

The documentation includes:
- Detailed endpoint descriptions
- Request/response schemas
- Interactive API testing interface
- Authentication requirements (if any)

## API Endpoints

### Reward Vault Endpoints

- `GET /allocations`: List all reward allocations
- `GET /allocations/:id`: Get allocation details
- `POST /allocations`: Create new allocation

### Merkle Endpoints

- `GET /merkle/:root`: Get merkle tree details
- `GET /merkle/:root/proof/:address`: Get merkle proof for address
- `POST /merkle/verify`: Verify merkle proof

### Claim Endpoints

- `GET /claims/:allocationId`: Get allocation claims
- `POST /claims/:allocationId/verify`: Verify claim proof

## Database Schema

The indexer uses Prisma with PostgreSQL. Key models include:

- `Allocation`: Reward allocation details and parameters
- `Claim`: User claim records
- `MerkleTree`: Merkle tree data and proofs

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