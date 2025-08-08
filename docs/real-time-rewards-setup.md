# Real-Time Rewards System & Bop It Game

This document describes the complete setup for the real-time rewards system and the interactive Bop It game contract on Berachain Bepolia testnet.

## Overview

The system consists of:
1. **RewardVaultManagerRealTimeFactory** - Factory for deploying real-time reward managers
2. **RewardVaultManagerRealTime** - Manager contract for real-time BGT distribution
3. **BopIt** - Interactive game contract with multiple actions and cooldowns
4. **RewardVaultFactory** - External Berachain factory for creating reward vaults

## Contract Addresses

### Deployed Contracts
- **RewardVaultManagerRealTimeFactory**: `0x6807ee246ee005fb984DBfCd2Fc484e043459Bb2` ✅ **VERIFIED**
- **RewardVaultManagerRealTime** (Latest): `0x1b42805C4276e9390383AcA1690efa4Db033a7e7` ✅ **DEPLOYED**
- **RewardVaultToken**: `0xB08E21bD25345e0495696b0fC9F229e8a8Ce71F0` ✅ **DEPLOYED**
- **BopIt Game Contract**: `0x3cc7Dcc72c063A6F48b8491F7484CC9e7C33eF92` ⚠️ **PENDING DEPLOYMENT** (Insufficient funds)

### External Contracts
- **RewardVaultFactory** (Berachain): `0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8`
- **Liquid BGT Minter**: `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681`
- **FBGT Token**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece`

## Deployment Process

### Step 1: Deploy Real-Time Manager via Factory

```solidity
// Interface for the factory
interface IRewardVaultManagerRealTimeFactory {
    function deployRealTimeManager() external returns (address manager, address rewardVaultToken);
}

// Deployment call
IRewardVaultManagerRealTimeFactory factory = IRewardVaultManagerRealTimeFactory(0x6807ee246ee005fb984DBfCd2Fc484e043459Bb2);
(address manager, address rewardVaultToken) = factory.deployRealTimeManager();
```

### Step 2: Create Reward Vault via Berachain Factory

```solidity
// Interface for the Berachain factory
interface IRewardVaultFactory {
    function createRewardVault(address stakingToken) external returns (address);
}

// Create reward vault
IRewardVaultFactory berachainFactory = IRewardVaultFactory(0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8);
address rewardVault = berachainFactory.createRewardVault(rewardVaultToken);
```

### Step 3: Configure Real-Time Manager

```solidity
// Interface for the real-time manager
interface IRewardVaultManagerRealTime {
    function registerRewardVault(address rewardVault) external;
    function setLiquidBGTMinter(address minter, address token) external;
    function setDistributorWhitelist(address distributor, bool isWhitelisted) external;
}

// Configure the manager
IRewardVaultManagerRealTime manager = IRewardVaultManagerRealTime(managerAddress);
manager.registerRewardVault(rewardVault);
manager.setLiquidBGTMinter(0x0d91683c12313d0a35A95Bb14a16bCAa208bf681, 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece);
```

### Step 4: Deploy Bop It Contract

```solidity
// Deploy Bop It with manager address
BopIt bopIt = new BopIt(managerAddress);
```

### Step 5: Whitelist Bop It as Distributor

```solidity
// Whitelist the Bop It contract
manager.setDistributorWhitelist(address(bopIt), true);
```

## UI Deployment Wizard

### Step 1: Deploy Real-Time Manager
- **Action**: Call `deployRealTimeManager()` on factory
- **Factory Address**: `0x6807ee246ee005fb984DBfCd2Fc484e043459Bb2`
- **Parameters**: None
- **Returns**: `(address manager, address rewardVaultToken)`
- **Gas Estimate**: ~2.4M gas

### Step 2: Create Reward Vault
- **Action**: Call `createRewardVault(address)` on Berachain factory
- **Factory Address**: `0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8`
- **Parameters**: `stakingToken` (use the rewardVaultToken from step 1)
- **Returns**: `address rewardVault`
- **Gas Estimate**: ~1M gas

### Step 3: Configure Manager
- **Action 1**: Call `registerRewardVault(address)` on manager
- **Parameters**: `rewardVault` (from step 2)
- **Gas Estimate**: ~50K gas

- **Action 2**: Call `setLiquidBGTMinter(address,address)` on manager
- **Parameters**: `minter` = `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681`, `token` = `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece`
- **Gas Estimate**: ~50K gas

### Step 4: Deploy Bop It
- **Action**: Deploy `BopIt` contract
- **Parameters**: `_rewardManager` = manager address from step 1
- **Gas Estimate**: ~1.5M gas

### Step 5: Whitelist Bop It
- **Action**: Call `setDistributorWhitelist(address,bool)` on manager
- **Parameters**: `distributor` = Bop It address, `isWhitelisted` = `true`
- **Gas Estimate**: ~50K gas

## Bop It Contract Mechanics

### Game Actions
The Bop It contract features 5 different actions inspired by the classic game:

1. **BOP** - Quick action (30s cooldown, 0.01 BERA reward)
2. **TWIST** - Medium action (1min cooldown, 0.02 BERA reward)
3. **PULL** - Slower action (1.5min cooldown, 0.03 BERA reward)
4. **SPIN** - Long action (2min cooldown, 0.04 BERA reward)
5. **FLICK** - Longest action (3min cooldown, 0.05 BERA reward)

### Cooldown System
- Each action has a unique cooldown period
- Cooldowns are tracked per player per action
- Players cannot perform the same action until cooldown expires
- Cooldown periods scale with reward amounts (higher rewards = longer cooldowns)

### Reward Distribution
- Each action triggers real-time BGT distribution
- Rewards are distributed immediately via the reward manager
- If insufficient balance, action fails gracefully (no revert)
- All rewards are sub 0.1 BERA as requested

### Player Experience
- Players can perform any action at any time (subject to cooldowns)
- Each action provides instant feedback and reward
- View functions allow checking remaining cooldown time
- Events emit for successful actions and cooldown failures

## Contract ABIs

### RewardVaultManagerRealTimeFactory ABI
```json
[
  {
    "inputs": [],
    "name": "deployRealTimeManager",
    "outputs": [
      {
        "internalType": "address",
        "name": "manager",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "rewardVaultToken",
        "type": "address"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "manager",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "deployer",
        "type": "address"
      }
    ],
    "name": "RealTimeManagerDeployed",
    "type": "event"
  }
]
```

### RewardVaultManagerRealTime ABI
```json
[
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "recipient",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "distributeRealTimeReward",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "rewardVault",
        "type": "address"
      }
    ],
    "name": "registerRewardVault",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "minter",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "token",
        "type": "address"
      }
    ],
    "name": "setLiquidBGTMinter",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "distributor",
        "type": "address"
      },
      {
        "internalType": "bool",
        "name": "isWhitelisted",
        "type": "bool"
      }
    ],
    "name": "setDistributorWhitelist",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "distributorWhitelist",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "rewardVaultToken",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  }
]
```

### BopIt ABI
```json
[
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_rewardManager",
        "type": "address"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "player",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "action",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "reward",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "ActionPerformed",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "player",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "action",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "remainingTime",
        "type": "uint256"
      }
    ],
    "name": "CooldownNotMet",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "bop",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "flick",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "player",
        "type": "address"
      }
    ],
    "name": "getBopCooldownRemaining",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "player",
        "type": "address"
      }
    ],
    "name": "getFlickCooldownRemaining",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "player",
        "type": "address"
      }
    ],
    "name": "getPullCooldownRemaining",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "player",
        "type": "address"
      }
    ],
    "name": "getSpinCooldownRemaining",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "player",
        "type": "address"
      }
    ],
    "name": "getTwistCooldownRemaining",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "lastBopTime",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "lastFlickTime",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "lastPullTime",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "lastSpinTime",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "lastTwistTime",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "pull",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "rewardManager",
    "outputs": [
      {
        "internalType": "contract IRewardVaultManagerRealTime",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_rewardManager",
        "type": "address"
      }
    ],
    "name": "setRewardManager",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "spin",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "twist",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
]
```

### RewardVaultFactory ABI (External Berachain Contract)
```json
[
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "stakingToken",
        "type": "address"
      }
    ],
    "name": "createRewardVault",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "stakingToken",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "vault",
        "type": "address"
      }
    ],
    "name": "VaultCreated",
    "type": "event"
  }
]
```

## Network Configuration

- **Network**: Berachain Bepolia Testnet
- **Chain ID**: 80069
- **RPC URL**: `https://bepolia.rpc.berachain.com`
- **Block Explorer**: `https://testnet.berascan.com`
- **Currency**: BERA (native token)

## Usage Examples

### Deploying via UI
1. Connect wallet to Berachain Bepolia testnet
2. Navigate to deployment wizard
3. Follow the 5-step process outlined above
4. Each step shows gas estimates and required parameters
5. Confirm transactions and wait for confirmations

### Playing Bop It
1. Connect wallet to the Bop It contract
2. Check cooldown remaining for each action
3. Click any action button (bop, twist, pull, spin, flick)
4. Confirm transaction
5. Receive instant BGT reward
6. Wait for cooldown to expire before repeating action

### Monitoring
- Use view functions to check cooldown remaining
- Monitor events for successful actions
- Track reward distributions via the reward manager
- Check Berascan for transaction history

## Security Considerations

- All contracts are owned and can be upgraded by the owner
- Distributor whitelist controls who can trigger rewards
- Cooldown system prevents spam and abuse
- Graceful failure handling for insufficient balances
- No admin functions that could drain user funds

## Testing

The system includes comprehensive test suites:
- Unit tests for all contract functions
- Integration tests for reward distribution
- Cooldown mechanism validation
- Event emission verification
- Access control testing

All tests pass and the system is ready for production use on the testnet.

## Deployment Status

### Completed Deployments
- ✅ **RewardVaultManagerRealTimeFactory**: Deployed and verified
- ✅ **RewardVaultManagerRealTime**: Deployed via factory
- ✅ **RewardVaultToken**: Deployed with manager

### Pending Deployments
- ⚠️ **BopIt Game Contract**: Pending deployment due to insufficient funds
  - **Required Gas**: ~0.067 BERA
  - **Current Balance**: ~0.04 BERA
  - **Action Needed**: Add more BERA to deployer wallet

### Deployment Instructions
To complete the deployment:

1. **Add funds to deployer wallet**: `0xC8B2FE82bc31e8b2aDA6514a3d4F3d2cA131e926`
2. **Deploy Bop It contract**:
   ```bash
   forge script script/DeployBopIt.s.sol --rpc-url https://bepolia.rpc.berachain.com --broadcast
   ```
3. **Verify the contract**:
   ```bash
   source .env && forge verify-contract <DEPLOYED_ADDRESS> src/examples/BopIt.sol:BopIt --chain-id 80069 --watch --verifier-url https://api-testnet.berascan.com/api --constructor-args 0000000000000000000000001b42805c4276e9390383aca1690efa4db033a7e7
   ```
4. **Whitelist as distributor**:
   ```solidity
   manager.setDistributorWhitelist(<BOP_IT_ADDRESS>, true);
   ``` 