// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MerkleManagerFactory} from "../src/utilities/MerkleManagerFactory.sol";
import {RewardVaultManagerRealTimeFactory} from "../src/utilities/RewardVaultManagerRealTimeFactory.sol";

/// @notice Deploys two factory contracts using RV_UTILS_PK
/// @dev Deploys MerkleManagerFactory and RewardVaultManagerRealTimeFactory
contract DeployAllFactories is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("RV_UTILS_PK");
        vm.startBroadcast(deployerPrivateKey);

        console.log("=== Deploying All Factories with RV_UTILS_PK ===");

        // 1. Deploy MerkleManagerFactory
        console.log("\n--- Deploying MerkleManagerFactory ---");
        MerkleManagerFactory merkleFactory = new MerkleManagerFactory();
        console.log("MerkleManagerFactory deployed at:", address(merkleFactory));
        console.log("Reward Vault Factory (hardcoded):", merkleFactory.rewardVaultFactory());
        console.log("Factory owner:", merkleFactory.owner());

        // 2. Deploy RewardVaultManagerRealTimeFactory
        console.log("\n--- Deploying RewardVaultManagerRealTimeFactory ---");
        RewardVaultManagerRealTimeFactory realTimeFactory = new RewardVaultManagerRealTimeFactory();
        console.log("RewardVaultManagerRealTimeFactory deployed at:", address(realTimeFactory));

        console.log("\n=== Deployment Summary ===");
        console.log("MerkleManagerFactory:", address(merkleFactory));
        console.log("RewardVaultManagerRealTimeFactory:", address(realTimeFactory));
        console.log("\nBoth factories deployed successfully!");

        vm.stopBroadcast();
    }
}
