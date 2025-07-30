# Verifying Contracts on Berachain Testnet

Quick guide for verifying contracts with Foundry on Berachain testnet.

## Setup

Add to your `.env`:
```bash
ETHERSCAN_API_KEY=your_api_key_here
RPC_URL=https://bepolia.rpc.berachain.com
```

## Basic Command

```bash
forge verify-contract <ADDRESS> <CONTRACT_PATH>:<CONTRACT_NAME> \
  --watch \
  --verifier-url https://api-testnet.berascan.com/api \
  --rpc-url https://bepolia.rpc.berachain.com \
  --chain-id 80069
```

## With Constructor Arguments

```bash
forge verify-contract <ADDRESS> <CONTRACT_PATH>:<CONTRACT_NAME> \
  --watch \
  --verifier-url https://api-testnet.berascan.com/api \
  --rpc-url https://bepolia.rpc.berachain.com \
  --chain-id 80069 \
  --constructor-args $(cast abi-encode "constructor(<TYPES>)" <VALUES>)
```

## Example: MerkleManagerFactory

```bash
forge verify-contract 0x89a2e4bd1cfbf5D4C34C67606826922aB3e7D5Fd \
  src/utilities/MerkleManagerFactory.sol:MerkleManagerFactory \
  --watch \
  --verifier-url https://api-testnet.berascan.com/api \
  --rpc-url https://bepolia.rpc.berachain.com \
  --chain-id 80069 \
  --constructor-args $(cast abi-encode "constructor(address)" 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8)
```

## Common Issues

**"No matching artifact found"** → Run `forge build` first

**"Invalid API URL"** → Use `https://api-testnet.berascan.com/api` for testnet

**"Compiler version must be provided"** → Add `--compiler-version 0.8.26`

## Tips

- Always `forge build` before verifying
- Check constructor args match deployment
- Use correct API URL for your network (testnet vs mainnet)
- Verify contract path is correct relative to project root 