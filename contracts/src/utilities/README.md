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