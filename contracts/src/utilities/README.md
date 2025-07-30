# Utilities

This folder contains utility contracts that provide common functionality for the project.

## TokenFactory

The `TokenFactory` is a utility contract that allows anyone to create ERC20 tokens with custom parameters.

### Features

- Create ERC20 tokens with custom name, symbol, decimals, and total supply
- Automatically makes the creator (msg.sender) the owner of the token
- Mints the full supply to the creator
- Uses Solmate's ERC20 and Owned contracts for gas efficiency
- Includes comprehensive input validation

### Usage

```solidity
// Deploy the factory
TokenFactory factory = new TokenFactory();

// Create a new token
address tokenAddress = factory.createToken(
    "My Token",    // name
    "MTK",         // symbol
    18,            // decimals
    1000000 * 10**18  // total supply (1 million tokens)
);

// The creator now owns the full supply and is the owner
FactoryToken token = FactoryToken(tokenAddress);
```

### Contract Details

- **TokenFactory**: Main factory contract with the `createToken` function
- **FactoryToken**: The ERC20 token contract that gets deployed by the factory
  - Inherits from Solmate's `ERC20` and `Owned`
  - Constructor mints the full supply to the owner
  - Owner can mint additional tokens if needed

### Events

- `TokenCreated`: Emitted when a new token is created
  - `token`: Address of the created token
  - `name`: Token name
  - `symbol`: Token symbol
  - `decimals`: Token decimals
  - `totalSupply`: Total supply
  - `owner`: Token owner

### Errors

- `ZeroTotalSupply`: Thrown when trying to create a token with zero total supply
- `EmptyNameOrSymbol`: Thrown when name or symbol is empty

### Testing

Run the tests with:
```bash
forge test --match-contract TokenFactoryTest
```

### Deployment

Deploy using the provided script:
```bash
forge script script/DeployTokenFactory.s.sol --rpc-url <RPC_URL> --broadcast
```

## MerkleManagerFactory

The `MerkleManagerFactory` is a utility contract that automates the deployment of complete merkle reward vault manager setups.

### Features

- Deploys all necessary contracts in a single transaction
- Automatically sets up the complete merkle manager ecosystem
- Handles contract initialization and ownership transfers
- Uses the existing reward vault factory for vault creation
- Includes comprehensive error handling

### Usage

```solidity
// Deploy the factory (requires reward vault factory address)
MerkleManagerFactory factory = new MerkleManagerFactory(rewardVaultFactoryAddress);

// Deploy a complete merkle manager setup
(
    address manager,
    address rewardVaultToken,
    address fbgt,
    address liquidBGTMinter
) = factory.deployMerkleManager();
```

### What Gets Deployed

1. **RewardVaultManagerMerkle**: The main merkle manager contract (owned by deployer)
2. **RewardVaultToken**: Staking token for the reward vault
3. **Uses existing FBGT**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece`
4. **Uses existing LiquidBGTMinter**: `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681`

### Setup Process

1. Deploys `RewardVaultManagerMerkle` with its own `RewardVaultToken`
2. Sets the existing `LiquidBGTMinter` and `FBGT` token on the manager
3. Transfers ownership of the manager to the deployer
4. **RewardVault creation**: Will be handled via UI wizard later

### Events

- `MerkleManagerDeployed`: Emitted when a new setup is deployed
  - `manager`: Address of the RewardVaultManagerMerkle
  - `fbgt`: Address of the existing FBGT token
  - `liquidBGTMinter`: Address of the existing LiquidBGTMinter
  - `rewardVaultToken`: Address of the RewardVaultToken
  - `deployer`: Address that deployed the setup

### Errors

- `ZeroRewardVaultFactory`: Thrown when reward vault factory address is zero
- `RewardVaultCreationFailed`: Thrown when reward vault creation fails
- `InitializationFailed`: Thrown when manager initialization fails

### Testing

Run the tests with:
```bash
forge test --match-contract MerkleManagerFactoryTest
```

### Deployment

Deploy using the provided script:
```bash
forge script script/DeployMerkleManagerFactory.s.sol --rpc-url <RPC_URL> --broadcast
```

## LootBoxFactory

The `LootBoxFactory` is a utility contract designed for interactive UI deployment of complete loot box systems with configurable parameters.

### Features

- **UI-Friendly Design**: Structured for easy integration with web interfaces
- **Multiple Deployment Options**: Quick defaults, custom NFT settings, or full customization
- **Configurable Parameters**: Rarity probabilities, reward rates, NFT metadata, and more
- **Validation System**: Built-in configuration validation for UI feedback
- **Default Presets**: Sensible defaults for quick deployment
- **Complete Setup**: Deploys all necessary contracts and sets up relationships

### Usage

```solidity
// Deploy with defaults (quickest option)
(
    address lootBox,
    address lootBoxVault,
    address rewardVault,
    address rewardVaultToken
) = factory.deployLootBoxSystemWithDefaults();

// Deploy with custom NFT settings
(
    address lootBox,
    address lootBoxVault,
    address rewardVault,
    address rewardVaultToken
) = factory.deployLootBoxSystemWithCustomNFT(
    "MyLootBox",
    "MLB",
    "https://my.example.com/metadata/"
);

// Deploy with full custom configuration
LootBoxConfig memory config = LootBoxConfig({
    name: "PremiumLootBox",
    symbol: "PREMIUM",
    baseURI: "https://premium.example.com/metadata/",
    rarityProbabilities: [6000, 3000, 800, 150, 50], // 60%, 30%, 8%, 1.5%, 0.5%
    rarityRewardBips: [5, 50, 250, 1000, 2500],     // 0.05%, 0.5%, 2.5%, 10%, 25%
    entropyContract: entropyContractAddress,
    defaultEntropyProvider: entropyProviderAddress,
    liquidBGTMinter: liquidBGTMinterAddress,
    liquidBGTToken: liquidBGTTokenAddress,
    rewardVaultFactory: rewardVaultFactoryAddress
});

(
    address lootBox,
    address lootBoxVault,
    address rewardVault,
    address rewardVaultToken
) = factory.deployLootBoxSystem(config);
```

### What Gets Deployed

1. **LootBox NFT**: ERC-721 contract for loot box tokens (owned by deployer)
2. **RewardVaultLootBox**: Main loot box system controller
3. **RewardVault**: Created via the reward vault factory
4. **RewardVaultToken**: Staking token for the reward vault

### Configuration Options

#### NFT Configuration
- `name`: Collection name (e.g., "LootBox", "PremiumLootBox")
- `symbol`: Collection symbol (e.g., "LOOT", "PREMIUM")
- `baseURI`: Base URI for NFT metadata

#### Rarity & Reward Configuration
- `rarityProbabilities`: Array of 5 probabilities in basis points (10000 = 100%)
- `rarityRewardBips`: Array of 5 reward rates in basis points for each rarity

#### Entropy Configuration
- `entropyContract`: Pyth Entropy contract address
- `defaultEntropyProvider`: Default entropy provider address

#### Integration Configuration
- `liquidBGTMinter`: Liquid BGT minter contract address
- `liquidBGTToken`: Liquid BGT token address
- `rewardVaultFactory`: Reward vault factory address

### Default Configuration

The factory comes with sensible defaults:
- **NFT**: "LootBox" / "LOOT" / "https://example.com/metadata/"
- **Rarity Probs**: [5000, 4000, 900, 90, 10] (50%, 40%, 9%, 0.9%, 0.1%)
- **Reward Bips**: [10, 100, 500, 2000, 5000] (0.1%, 1%, 5%, 20%, 50%)
- **Integration**: Uses existing deployed contracts on Berachain testnet

### Events

- `LootBoxSystemDeployed`: Emitted when a new system is deployed
  - `lootBox`: Address of the LootBox NFT contract
  - `lootBoxVault`: Address of the RewardVaultLootBox contract
  - `rewardVault`: Address of the created RewardVault
  - `rewardVaultToken`: Address of the RewardVaultToken
  - `deployer`: Address that deployed the system
  - `config`: The configuration used for deployment

### Validation

The factory includes comprehensive validation:
- **Array Lengths**: Ensures rarity arrays have exactly 5 elements
- **Probability Sum**: Validates probabilities sum to 10000 bips (100%)
- **Address Validation**: Ensures all addresses are non-zero
- **String Validation**: Ensures name and symbol are not empty

### UI Integration Features

- **`validateConfig()`**: Validate configuration without deploying
- **`getDefaultConfig()`**: Get current default configuration
- **`updateDefaultConfig()`**: Update factory defaults
- **Multiple deployment methods**: From quick defaults to full customization

### Testing

Run the tests with:
```bash
forge test --match-contract LootBoxFactoryTest
```

### Deployment

Deploy using the provided script:
```bash
forge script script/DeployLootBoxFactory.s.sol --rpc-url <RPC_URL> --broadcast
``` 