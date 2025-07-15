// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";

contract DeployerAllocationAndClaim is Script {
    address private constant REWARD_VAULT_MANAGER = 0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3;
    address private constant FBGT = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;
    address private constant DEPLOYER = 0xC8B2FE82bc31e8b2aDA6514a3d4F3d2cA131e926;

    bytes32 private constant MERKLE_ROOT = 0xe395c3381aa81519e5cf36a5bf0adc96f92463bf6ed0bffe7dc53f059ba68105;
    bytes32 private constant CLAIM_ID = 0x320eaf069b6d50c14f74a70eaf3b909bbc8f4a974c79bd80277b23c91b04c8c4;
    uint256 private constant AMOUNT = 10000e18;

    function run() external {
        RewardVaultManagerMerkle manager = RewardVaultManagerMerkle(REWARD_VAULT_MANAGER);
        bytes32[] memory proof = new bytes32[](0);

        // Create allocation
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        manager.createAllocation(MERKLE_ROOT, AMOUNT, FBGT);
        vm.stopBroadcast();

        // Claim once
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        manager.claim(MERKLE_ROOT, CLAIM_ID, FBGT, AMOUNT, proof);
        vm.stopBroadcast();
    }
} 