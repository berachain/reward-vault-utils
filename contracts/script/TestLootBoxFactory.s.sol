// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {LootBoxFactory} from "../src/utilities/LootBoxFactory.sol";

/// @notice Test script to demonstrate LootBoxFactory usage
contract TestLootBoxFactory is Script {
    // Factory address (will be set after deployment)
    address public factoryAddress;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Test 1: Deploy with defaults
        console.log("=== Test 1: Deploy with Defaults ===");
        LootBoxFactory factory = LootBoxFactory(factoryAddress);
        
        (
            address lootBox,
            address lootBoxVault,
            address rewardVault,
            address rewardVaultToken
        ) = factory.deployLootBoxSystemWithDefaults();
        
        console.log("Deployed with defaults:");
        console.log("  - LootBox NFT:", lootBox);
        console.log("  - LootBox Vault:", lootBoxVault);
        console.log("  - Reward Vault:", rewardVault);
        console.log("  - Reward Vault Token:", rewardVaultToken);

        // Test 2: Deploy with custom NFT settings
        console.log("\n=== Test 2: Deploy with Custom NFT ===");
        
        (
            address customLootBox,
            address customLootBoxVault,
            address customRewardVault,
            address customRewardVaultToken
        ) = factory.deployLootBoxSystemWithCustomNFT(
            "CustomLootBox",
            "CUSTOM",
            "https://custom.example.com/metadata/"
        );
        
        console.log("Deployed with custom NFT:");
        console.log("  - LootBox NFT:", customLootBox);
        console.log("  - LootBox Vault:", customLootBoxVault);
        console.log("  - Reward Vault:", customRewardVault);
        console.log("  - Reward Vault Token:", customRewardVaultToken);

        // Test 3: Deploy with full custom configuration
        console.log("\n=== Test 3: Deploy with Full Custom Config ===");
        
        LootBoxFactory.LootBoxConfig memory customConfig = LootBoxFactory.LootBoxConfig({
            // NFT Configuration
            name: "PremiumLootBox",
            symbol: "PREMIUM",
            baseURI: "https://premium.example.com/metadata/",
            
            // Rarity & Reward Configuration
            rarityProbabilities: new uint256[](5),
            rarityRewardBips: new uint256[](5),
            
            // Entropy Configuration (use same as defaults)
            entropyContract: 0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320,
            defaultEntropyProvider: 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344,
            
            // Integration Configuration (use same as defaults)
            liquidBGTMinter: 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681,
            liquidBGTToken: 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece,
            rewardVaultFactory: 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8
        });

        // Custom rarity probabilities: 60%, 30%, 8%, 1.5%, 0.5%
        customConfig.rarityProbabilities[0] = 6000; // COMMON (60%)
        customConfig.rarityProbabilities[1] = 3000; // UNCOMMON (30%)
        customConfig.rarityProbabilities[2] = 800;  // RARE (8%)
        customConfig.rarityProbabilities[3] = 150;  // EPIC (1.5%)
        customConfig.rarityProbabilities[4] = 50;   // LEGENDARY (0.5%)

        // Custom reward bips
        customConfig.rarityRewardBips[0] = 5;     // COMMON (0.05%)
        customConfig.rarityRewardBips[1] = 50;    // UNCOMMON (0.5%)
        customConfig.rarityRewardBips[2] = 250;   // RARE (2.5%)
        customConfig.rarityRewardBips[3] = 1000;  // EPIC (10%)
        customConfig.rarityRewardBips[4] = 2500;  // LEGENDARY (25%)

        (
            address premiumLootBox,
            address premiumLootBoxVault,
            address premiumRewardVault,
            address premiumRewardVaultToken
        ) = factory.deployLootBoxSystem(customConfig);
        
        console.log("Deployed with full custom config:");
        console.log("  - LootBox NFT:", premiumLootBox);
        console.log("  - LootBox Vault:", premiumLootBoxVault);
        console.log("  - Reward Vault:", premiumRewardVault);
        console.log("  - Reward Vault Token:", premiumRewardVaultToken);

        console.log("\n=== Factory Test Complete ===");
        console.log("All deployment methods tested successfully!");

        vm.stopBroadcast();
    }
} 