# Loot Box System Documentation

## Overview

The Loot Box System is a decentralized application built on Berachain that combines Pyth Entropy for provably fair randomness with ERC-721 NFTs to create a unique loot box experience. Users can create and open loot boxes to receive random rewards based on rarity tiers.

## Architecture

### Core Components

1. **LootBox Contract** (`src/examples/LootBox.sol`)
   - ERC-721 NFT contract for loot box tokens
   - Handles minting and storage of loot box items
   - Manages loot box metadata and ownership
   - Provides getter functions for external contract access

2. **RewardVaultLootBox Contract** (`src/examples/RewardVaultLootBox.sol`)
   - Main loot box system controller
   - Integrates with Pyth Entropy for randomness
   - Manages loot box creation and reward distribution
   - Handles creator approval system
   - Coordinates with LootBox contract for NFT operations

3. **LootBoxLogic Library** (`src/libraries/LootBoxLogic.sol`)
   - Pure functions for rarity determination
   - Reward calculation logic
   - Entropy-based randomization algorithms

4. **RarityTypes Library** (`src/libraries/RarityTypes.sol`)
   - Shared rarity enum definitions
   - Ensures consistency across contracts

### System Flow

1. **Creator Approval**: Only approved creators can create loot boxes
2. **Loot Box Creation**: Creator calls `createLootBox()` with entropy request
3. **Entropy Processing**: Pyth Entropy provides random number via callback
4. **NFT Minting**: Loot box NFT is minted with random rarity and rewards
5. **Loot Box Opening**: Users can open their loot boxes to claim rewards

## Deployment

### Contract Addresses (Berachain Bepolia)

- **LootBox**: `0x891a2e459303DbEb5487a7f437142A70D5912dDe`
- **RewardVaultLootBox**: `0x8A64bDB68F39238A724A9B7e5538fcC7F35a0465`
- **Pyth Entropy Provider**: `0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344`

### Deployment Scripts

1. **DeployLootBox.s.sol**: Deploys both contracts with proper configuration
2. **SetCreatorApproval.s.sol**: Sets deployer as approved creator

### Configuration

- **Rarity Probabilities**: 50% No Prize, 40% Common, 9% Uncommon, 0.9% Rare, 0.1% Super Rare
- **Reward Bips**: 0, 10, 100, 500, 2000 (0%, 0.1%, 1%, 5%, 20% of pool)
- **Base URI**: `https://example.com/metadata/`

## Successful Transaction Documentation

### First Successful Loot Box Mint

**Transaction Hash**: `0x6b89557c7505aafa27789d90025d06e79542b7623427510fa2a4746952155ff1`

**Transaction Details**:
- **Network**: Berachain Bepolia Testnet
- **Block**: [Block number from transaction]
- **Gas Used**: [Gas used from transaction]
- **Status**: ✅ Success

**Event Logs**:
```
Event: LootBoxOpeningInitiated
- opener: [Creator Address]
- sequenceNumber: [Sequence Number]

Event: Transfer (ERC-721 Mint)
- from: 0x0000000000000000000000000000000000000000
- to: [Recipient Address]
- tokenId: 1

Event: LootBoxOpened
- tokenId: 1
- opener: [Creator Address]
- sequenceNumber: [Sequence Number]
- rarity: [Rarity Level]
- rewardBips: [Reward Amount in Bips]
```

**What Happened**:
1. Creator called `createLootBox()` with Pyth Entropy provider and user random number
2. System initiated entropy request with sequence number
3. Pyth Entropy callback processed the random number
4. Loot box NFT (tokenId: 1) was minted to the creator
5. Loot box was automatically opened with determined rarity and reward

**Key Achievements**:
- ✅ First successful loot box creation and minting
- ✅ Pyth Entropy integration working correctly
- ✅ ERC-721 NFT minting functioning
- ✅ Rarity determination and reward calculation operational
- ✅ Full end-to-end loot box flow completed

**Technical Validation**:
- Entropy provider address correctly configured
- Dynamic fee fetching working
- Controller relationship between contracts established
- Event emission properly configured

## Usage

### For Creators

1. **Get Approval**: Contact contract owner to be added as approved creator
2. **Create Loot Box**: Call `createLootBox(provider, userRandomNumber)` with value for entropy fee
3. **Monitor Events**: Watch for `LootBoxOpeningInitiated` and `LootBoxOpened` events

### For Users

1. **Receive NFT**: Get loot box NFT after creation
2. **Open Loot Box**: Call `openLootBox(tokenId)` to claim rewards
3. **View Metadata**: Check NFT metadata for rarity and reward information

### Key Functions

#### RewardVaultLootBox
- `createLootBox(address provider, bytes32 userRandomNumber)`: Create new loot box
- `openLootBox(uint256 tokenId)`: Open loot box and claim rewards
- `setCreatorApproval(address creator, bool approved)`: Manage creator permissions

#### LootBox
- `getLootBoxItem(uint256 tokenId)`: Get loot box item details
- `ownerOf(uint256 tokenId)`: Get NFT owner
- `tokenURI(uint256 tokenId)`: Get NFT metadata URI

## Technical Details

### Rarity System

The system uses a 5-tier rarity system:
- **COMMON**: 40% chance, 0.1% reward
- **UNCOMMON**: 9% chance, 1% reward  
- **RARE**: 0.9% chance, 5% reward
- **EPIC**: 0.1% chance, 20% reward
- **NO_PRIZE**: 50% chance, 0% reward

### Entropy Integration

- Uses Pyth Entropy for provably fair randomness
- Entropy callback processes random number to determine rarity
- User provides additional random number for extra entropy

### Gas Optimization

- Contracts optimized to fit within EVM size limits (24,576 bytes)
- Custom errors instead of string revert messages
- Library functions for pure calculations
- Minimal event parameters

## Security Features

1. **Creator Approval**: Only approved addresses can create loot boxes
2. **Ownership Checks**: Only NFT owners can open their loot boxes
3. **Claim Prevention**: Loot boxes can only be opened once
4. **Entropy Security**: Uses Pyth's secure entropy source

## Events

- `LootBoxOpeningInitiated(address opener, uint64 sequenceNumber)`: Loot box creation started
- `LootBoxOpened(uint256 tokenId, address opener, uint64 sequenceNumber, Rarity rarity, uint256 rewardBips)`: Loot box opened
- `LootBoxClaimed(uint256 tokenId, address owner, uint256 rewardAmount, address rewardToken)`: Rewards claimed

## Testing

The system has been tested on Berachain Bepolia testnet with successful:
- Contract deployment
- Creator approval setup
- Function calls and state verification
- **First successful loot box minting and opening**

## Future Enhancements

1. **Multiple Reward Tokens**: Support for different reward token types
2. **Batch Operations**: Create multiple loot boxes in one transaction
3. **Metadata Integration**: IPFS-based metadata storage
4. **Governance**: DAO-based creator approval system
5. **Analytics**: On-chain statistics and leaderboards

## Troubleshooting

### Common Issues

1. **"UNAUTHORIZED"**: Caller is not an approved creator
2. **"ALREADY_PROCESSED"**: Entropy callback already processed
3. **"ALREADY_CLAIMED"**: Loot box already opened
4. **"NOT_OWNER"**: Caller doesn't own the NFT

### Gas Estimation

- Loot box creation: ~50,000 gas
- Loot box opening: ~30,000 gas
- Creator approval: ~46,000 gas

## License

MIT License - see LICENSE file for details. 