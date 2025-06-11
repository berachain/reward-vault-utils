# Liquid BGT Minting Process

This document explains the process of minting Liquid BGT tokens based on the reference transaction: [0xf14163480f90499675c6d8354fc8ec885138fa89c9c42eb4ae5002f09bba03bf](https://testnet.berascan.com/tx/0xf14163480f90499675c6d8354fc8ec885138fa89c9c42eb4ae5002f09bba03bf)

## Transaction Flow

1. **Initial Call**
   - Function: `mintLiquidBGT()`
   - Method ID: `0x4ab57f62`
   - From: `0xC8B2FE82bc31e8b2aDA6514a3d4F3d2cA131e926`
   - To: `0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3` (RewardVaultManagerMerkle)

2. **Token Transfers**
   - BGT Transfer: 29.598854999452843248 BGT from `0xD2f19a79...113940761` to `0x0d91683c...a208bf681`
   - FBGT Transfer: 29.598854999452843248 FBGT from `0x00000000...000000000` to `0x9f6A372c...9212bdEa3`

3. **Internal Transactions**
   - The contract call produced 8 internal transactions
   - Key interactions:
     - Call to LiquidBGTMinter (`0x0d91683c...a208bf681`)
     - Static call to `0x656b95E5...18Ceb1dba`
     - Call to `0x049F3186...Df752c6f5`

4. **Event Logs**
   - Transfer event for BGT tokens
   - RewardPaid event for the minting reward
   - Transfer event for FBGT tokens
   - TokensMinted event for the minted tokens
   - FBGTMinted event for the minted FBGT

## Gas Usage
- Gas Used: 228,019 (66.74% of limit)
- Gas Price: 20.000000007 Gwei
- Total Cost: 0.004560380001596133 BERA

## Key Contracts
- RewardVaultManagerMerkle: `0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3`
- LiquidBGT: `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681`
- LiquidBGTMinter: `0x0d91683c12313d0a35A95Bb14a16bCAa208bf681`

## Process Summary
1. User calls `mintLiquidBGT()` on RewardVaultManagerMerkle
2. Contract interacts with LiquidBGTMinter
3. BGT tokens are transferred to the minter
4. FBGT tokens are minted and transferred to the manager
5. Events are emitted to track the minting process

## Implementation
To implement this process in your code:

```solidity
// Call the mintLiquidBGT function on the RewardVaultManagerMerkle contract
function mintLiquidBGT() external {
    // The function will:
    // 1. Transfer BGT tokens to the minter
    // 2. Mint FBGT tokens
    // 3. Update token accounting
    // 4. Emit relevant events
}
```

## Verification
You can verify the minting process by:
1. Checking the transaction receipt on Berascan
2. Monitoring the token balances before and after minting
3. Verifying the emitted events match the expected format 