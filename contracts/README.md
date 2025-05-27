# Competition Vault Contracts

Smart contracts for managing competitions and reward distribution on Berachain, integrated with proof of liquidity mechanisms.

## Overview

The Competition Vault contracts provide a framework for:
- Creating and managing competitions
- Tracking user participation
- Integrating with Berachain's proof of liquidity
- Distributing rewards based on participation and liquidity metrics

## Contract Structure

- `CompetitionVault.sol`: Main contract for competition management and reward distribution
- `RewardVault.sol`: Handles reward token distribution and merkle root verification
- `ButtonPress.sol`: Tracks user participation in competitions

## Development Setup

### Prerequisites

- Foundry
- Node.js (v18 or later)
- Git

### Installation

```bash
# Install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test
```

## Contract Integration

### Competition Creation

```solidity
function createCompetition(
    uint256 startTime,
    uint256 endTime,
    uint256 rewardAmount
) external returns (uint256 competitionId)
```

### Participation

```solidity
function participate(uint256 competitionId) external
```

### Reward Distribution

```solidity
function claimReward(
    uint256 competitionId,
    uint256 amount,
    bytes32[] calldata proof
) external
```

## Testing

```bash
# Run all tests
forge test

# Run specific test
forge test --match-test testName

# Run with verbose output
forge test -vvv
```

## Deployment

1. Update the configuration in `script/Deploy.s.sol`
2. Run the deployment script:
```bash
forge script script/Deploy.s.sol --rpc-url <RPC_URL> --broadcast
```

## Deployed Contract Addresses

- **CompetitionManagerMerkle**: `0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519`
- **CompetitionToken**: `0xC7f2Cf4845C6db0e1a1e91ED41Bcd0FcC1b0E141`
- **RewardVault**: `0x87345fAa738117C1f161D060b192bb8548a599d8`
- **Button**: `0x90193C961A926261B756D1E5bb255e67ff9498A1`

## License

MIT 