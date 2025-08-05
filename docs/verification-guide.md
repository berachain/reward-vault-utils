# Contract Verification Guide

## Deployed Factories

### LootBoxFactory
- **Address**: `0x092E78918008b04C12FF05b5acD9D3b48597d9D1`
- **Contract**: `src/utilities/LootBoxFactory.sol`
- **Compiler**: Solidity 0.8.27
- **Optimization**: Enabled (200 runs)
- **Constructor Arguments**: None (no constructor parameters)

### RewardVaultLootBoxFactory
- **Address**: `0x758fe96BA82914ED774066C9222fCdd8fA26Cb4B`
- **Contract**: `src/utilities/RewardVaultLootBoxFactory.sol`
- **Compiler**: Solidity 0.8.27
- **Optimization**: Enabled (200 runs)
- **Constructor Arguments**: None (no constructor parameters)

## Automatic Verification Commands

### For LootBoxFactory:
```bash
source .env && forge verify-contract 0x092E78918008b04C12FF05b5acD9D3b48597d9D1 src/utilities/LootBoxFactory.sol:LootBoxFactory --chain-id 80069 --watch --verifier-url https://api-testnet.berascan.com/api
```

### For RewardVaultLootBoxFactory:
```bash
source .env && forge verify-contract 0x758fe96BA82914ED774066C9222fCdd8fA26Cb4B src/utilities/RewardVaultLootBoxFactory.sol:RewardVaultLootBoxFactory --chain-id 80069 --watch --verifier-url https://api-testnet.berascan.com/api
```

## Manual Verification Steps (if automatic fails)

### For LootBoxFactory:
1. Go to [Berascan Testnet](https://bepolia.beratrail.io/address/0x092e78918008b04c12ff05b5acd9d3b48597d9d1)
2. Click "Contract" tab
3. Click "Verify and Publish"
4. Select "Solidity (Single file)"
5. Compiler Type: `Solidity (Single file)`
6. Compiler Version: `0.8.27`
7. Optimization: `Yes`
8. Optimization runs: `200`
9. Source code: Copy the entire content of `src/utilities/LootBoxFactory.sol`
10. Constructor Arguments: Leave empty (no constructor)
11. Submit for verification

### For RewardVaultLootBoxFactory:
1. Go to [Berascan Testnet](https://bepolia.beratrail.io/address/0x758fe96ba82914ed774066c9222fcdd8fa26cb4b)
2. Click "Contract" tab
3. Click "Verify and Publish"
4. Select "Solidity (Single file)"
5. Compiler Type: `Solidity (Single file)`
6. Compiler Version: `0.8.27`
7. Optimization: `Yes`
8. Optimization runs: `200`
9. Source code: Copy the entire content of `src/utilities/RewardVaultLootBoxFactory.sol`
10. Constructor Arguments: Leave empty (no constructor)
11. Submit for verification

## Contract Sizes
- **LootBoxFactory**: 17,067 bytes ✅ (Under 24KB limit)
- **RewardVaultLootBoxFactory**: 1,179 bytes ✅ (Ultra-lightweight)

## Hardcoded Addresses
Both factories use these hardcoded addresses for Berachain Bepolia:
- **Entropy Contract**: `0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320`
- **Default Provider**: `0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344`

## FBGT Faucet

### FBGTFaucet
- **Address**: `0x2926F93c33D2198Be39aA90BFd06b857cdC8AB2D`
- **Contract**: `src/utilities/FBGTFaucet.sol`
- **Compiler**: Solidity 0.8.27
- **Optimization**: Enabled (200 runs)
- **Constructor Arguments**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece` (FBGT token address)

### Automatic Verification Command for FBGTFaucet:
```bash
source .env && forge verify-contract 0x2926F93c33D2198Be39aA90BFd06b857cdC8AB2D src/utilities/FBGTFaucet.sol:FBGTFaucet --chain-id 80069 --watch --verifier-url https://api-testnet.berascan.com/api --constructor-args 0000000000000000000000004ed091c61ddb2b2dc69d057284791fed9d640ece
```

### Manual Verification Steps for FBGTFaucet:
1. Go to [Berascan Testnet](https://bepolia.beratrail.io/address/0x2926f93c33d2198be39aa90bfd06b857cdc8ab2d)
2. Click "Contract" tab
3. Click "Verify and Publish"
4. Select "Solidity (Single file)"
5. Compiler Type: `Solidity (Single file)`
6. Compiler Version: `0.8.27`
7. Optimization: `Yes`
8. Optimization runs: `200`
9. Source code: Copy the entire content of `src/utilities/FBGTFaucet.sol`
10. Constructor Arguments: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece`
11. Submit for verification

### Contract Size
- **FBGTFaucet**: 5,432 bytes ✅ (Under 24KB limit)

### Hardcoded Addresses
The faucet uses this hardcoded address for Berachain Bepolia:
- **FBGT Token**: `0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece` 