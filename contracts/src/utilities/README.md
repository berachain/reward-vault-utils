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