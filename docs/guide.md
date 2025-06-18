# Reward Vault System Guide

This guide walks through the complete process of deploying and using the reward vault system, from contract deployment to claiming rewards.

## Prerequisites

- Node.js v18+
- pnpm
- Foundry
- PostgreSQL
- Docker (optional)

## 1. Deploy Contracts

### Environment Setup
```bash
# Copy environment file
cp .env.example .env

# Set your private key and RPC URL
PRIVATE_KEY=your_private_key
RPC_URL=https://bepolia.rpc.berachain.com
```

### Deploy All Contracts
```bash
# Deploy all contracts in sequence
forge script contracts/script/Deploy.s.sol --rpc-url $RPC_URL --broadcast
```

This will deploy:
1. FBGT token
2. LiquidBGTMinter
3. RewardVaultManagerMerkle
4. Set up all contract relationships

## 2. Press Button for Multiple Accounts

### Generate Test Accounts
```bash
cd indexer

# Create test accounts and press button
pnpm ts-node src/scripts/button-press.ts
```

This will:
1. Create multiple test accounts
2. Fund them with BGT
3. Press the button for each account
4. Record the events

## 3. Start the Indexer

### Database Setup
```bash
cd indexer

# Install dependencies
pnpm install

# Set up environment
cp .env.example .env

# Run migrations
pnpm prisma migrate dev
```

### Start Service
```bash
# Development mode
pnpm start:dev

# Or using Docker
docker compose up --build
```

The indexer will:
1. Connect to the blockchain
2. Start processing events
3. Build merkle trees
4. Provide API endpoints

## 4. Create Distribution

### Generate Distribution Data
```bash
# Create distribution and generate proofs
pnpm ts-node src/scripts/update-distribution-from-api.ts
```

This will:
1. Create a new distribution with the current time window
2. Calculate rewards for all participants
3. Generate merkle proofs for each participant
4. Save the complete distribution data to `distribution.json`
   - Distribution details (claimId, merkleRoot, etc.)
   - Participant list with their proofs
   - Reward amounts for each participant

The script will:
- Use existing time window if available
- Fall back to last 24 hours if no previous distribution
- Handle errors gracefully
- Save data in a format ready for on-chain allocation

## 5. Create On-Chain Allocation

### Deploy Allocation
```bash
# Create allocation with merkle root
forge script contracts/script/CreateAllocation.s.sol --rpc-url $RPC_URL --broadcast
```

This will:
1. Create new allocation
2. Set merkle root
3. Allocate rewards
4. Emit events

## 6. Claim Distribution

### Verify Proof
```bash
# Verify merkle proof
pnpm ts-node src/scripts/verify-merkle.ts

# Verify all proofs
pnpm ts-node src/scripts/verify-proofs.ts
```

### Claim Rewards
```bash
# Claim as user
forge script contracts/script/ClaimUser1.s.sol --rpc-url $RPC_URL --broadcast
```

This will:
1. Generate merkle proof
2. Submit claim transaction
3. Verify claim success
4. Update balances

## Verification Steps

After each step, verify the results:

1. **Contract Deployment**
   - Check contract addresses on Berascan
   - Verify contract code
   - Check initial state

2. **Button Presses**
   - Verify events in indexer
   - Check user balances
   - Confirm button press counts

3. **Distribution**
   - Check merkle root
   - Verify distribution amounts
   - Test proof generation

4. **Allocation**
   - Verify allocation on chain
   - Check token balances
   - Confirm merkle root

5. **Claims**
   - Verify claim success
   - Check final balances
   - Confirm events

## Troubleshooting

Common issues and solutions:

1. **Contract Deployment**
   - Insufficient gas
   - Wrong constructor arguments
   - Network issues

2. **Indexer**
   - Database connection issues
   - Event processing errors
   - API endpoint problems

3. **Claims**
   - Invalid merkle proofs
   - Insufficient balance
   - Wrong allocation ID

## Next Steps

1. Monitor the system
2. Add more test cases
3. Implement additional features
4. Scale the distribution

For more detailed information, refer to:
- [API Reference](./guides/api-reference.md)
- [Contract Addresses](./deployments/berachain-testnet.md)
- [Architecture Overview](./architecture/overview.md) 