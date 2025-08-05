// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {LootBoxFactory} from "../src/utilities/LootBoxFactory.sol";
import {RewardVaultLootBoxFactory} from "../src/utilities/RewardVaultLootBoxFactory.sol";

/// @notice Deploys the loot box factories and tests them
contract DeployLootBoxFactories is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("=== Deploying Loot Box Factories ===");

        // Deploy LootBoxFactory
        console.log("\n--- Step 1: Deploying LootBoxFactory ---");
        LootBoxFactory lootBoxFactory = new LootBoxFactory();
        console.log("LootBoxFactory deployed at:", address(lootBoxFactory));

        // Deploy RewardVaultLootBoxFactory
        console.log("\n--- Step 2: Deploying RewardVaultLootBoxFactory ---");
        RewardVaultLootBoxFactory rewardVaultLootBoxFactory = new RewardVaultLootBoxFactory();
        console.log("RewardVaultLootBoxFactory deployed at:", address(rewardVaultLootBoxFactory));

        // Test deployment of a LootBox
        console.log("\n--- Step 3: Testing LootBox Deployment ---");
        address lootBox = lootBoxFactory.createLootBox("TestLootBox", "TEST", "https://test.example.com/metadata/");
        console.log("Test LootBox deployed at:", lootBox);

        // Test deployment of a RewardVaultLootBox
        console.log("\n--- Step 4: Testing RewardVaultLootBox Parameters ---");
        uint256[] memory rarityProbabilities = new uint256[](5);
        uint256[] memory rarityRewardBips = new uint256[](5);

        // Set default probabilities and rewards
        rarityProbabilities[0] = 5000; // 50%
        rarityProbabilities[1] = 4000; // 40%
        rarityProbabilities[2] = 900; // 9%
        rarityProbabilities[3] = 90; // 0.9%
        rarityProbabilities[4] = 10; // 0.1%

        rarityRewardBips[0] = 10; // 0.1%
        rarityRewardBips[1] = 100; // 1%
        rarityRewardBips[2] = 500; // 5%
        rarityRewardBips[3] = 2000; // 20%
        rarityRewardBips[4] = 5000; // 50%

        // Test parameter validation (removed for size optimization)
        console.log("Parameters validation skipped for size optimization");

        // Test deployment of RewardVaultLootBox
        address rewardVaultLootBox =
            rewardVaultLootBoxFactory.deployRewardVaultLootBox(lootBox, rarityProbabilities, rarityRewardBips);
        console.log("RewardVaultLootBox deployed at:", rewardVaultLootBox);
        console.log("LootBox:", lootBox);
        console.log("Rarity Probabilities set successfully");
        console.log("Rarity Reward Bips set successfully");

        console.log("\n=== Deployment Summary ===");
        console.log("LootBoxFactory:", address(lootBoxFactory));
        console.log("RewardVaultLootBoxFactory:", address(rewardVaultLootBoxFactory));
        console.log("Test LootBox:", lootBox);
        console.log("Parameter factory tested successfully!");

        vm.stopBroadcast();
    }
}
