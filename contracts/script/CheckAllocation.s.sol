// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";

contract CheckAllocation is Script {
    address constant REWARD_VAULT_MANAGER = 0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3;
    bytes32 constant MERKLE_ROOT = 0x746371f265578c4e5bafa91380c80cab5b8c9e4126e7295e4a34077804d4b067;
    address constant FBGT = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

    function run() external view {
        RewardVaultManagerMerkle manager = RewardVaultManagerMerkle(REWARD_VAULT_MANAGER);
        (uint256 allocationAmount, uint256 claimedAmount, address rewardToken) = manager.tokenAllocations(MERKLE_ROOT);
        console.log("[FBGT] Allocation Amount:", allocationAmount);
        console.log("[FBGT] Claimed Amount:", claimedAmount);
        console.log("[FBGT] Reward Token:", rewardToken);
        console.log("Expected FBGT:", FBGT);
    }
} 