// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {LootBoxFactory} from "../src/utilities/LootBoxFactory.sol";

/// @notice Deploys the LootBoxFactory with default configuration for Berachain testnet
contract DeployLootBoxFactory is Script {
    // Berachain Bepolia testnet addresses
    address public constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;
    address public constant LIQUID_BGT_MINTER = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
    address public constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;
    address public constant ENTROPY_CONTRACT = 0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320;
    address public constant DEFAULT_ENTROPY_PROVIDER = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Create default configuration
        LootBoxFactory.LootBoxConfig memory defaultConfig = LootBoxFactory.LootBoxConfig({
            // NFT Configuration
            name: "LootBox",
            symbol: "LOOT",
            baseURI: "https://example.com/metadata/",
            
            // Rarity & Reward Configuration (5 values for 5 rarities)
            rarityProbabilities: new uint256[](5),
            rarityRewardBips: new uint256[](5),
            
            // Entropy Configuration
            entropyContract: ENTROPY_CONTRACT,
            defaultEntropyProvider: DEFAULT_ENTROPY_PROVIDER,
            
            // Integration Configuration
            liquidBGTMinter: LIQUID_BGT_MINTER,
            liquidBGTToken: FBGT_TOKEN,
            rewardVaultFactory: REWARD_VAULT_FACTORY
        });

        // Set rarity probabilities: 50%, 40%, 9%, 0.9%, 0.1% (in bips)
        defaultConfig.rarityProbabilities[0] = 5000; // COMMON (50%)
        defaultConfig.rarityProbabilities[1] = 4000; // UNCOMMON (40%)
        defaultConfig.rarityProbabilities[2] = 900;  // RARE (9%)
        defaultConfig.rarityProbabilities[3] = 90;   // EPIC (0.9%)
        defaultConfig.rarityProbabilities[4] = 10;   // LEGENDARY (0.1%)

        // Set reward bips for each rarity
        defaultConfig.rarityRewardBips[0] = 10;    // COMMON (0.1%)
        defaultConfig.rarityRewardBips[1] = 100;   // UNCOMMON (1%)
        defaultConfig.rarityRewardBips[2] = 500;   // RARE (5%)
        defaultConfig.rarityRewardBips[3] = 2000;  // EPIC (20%)
        defaultConfig.rarityRewardBips[4] = 5000;  // LEGENDARY (50%)

        // Deploy the factory
        LootBoxFactory factory = new LootBoxFactory(defaultConfig);
        
        console.log("=== LootBoxFactory Deployment ===");
        console.log("Factory deployed at:", address(factory));
        console.log("Default config set with:");
        console.log("  - NFT: %s (%s)", defaultConfig.name, defaultConfig.symbol);
        console.log("  - BaseURI:", defaultConfig.baseURI);
        console.log("  - Entropy Contract:", defaultConfig.entropyContract);
        console.log("  - Entropy Provider:", defaultConfig.defaultEntropyProvider);
        console.log("  - Liquid BGT Minter:", defaultConfig.liquidBGTMinter);
        console.log("  - Liquid BGT Token:", defaultConfig.liquidBGTToken);
        console.log("  - Reward Vault Factory:", defaultConfig.rewardVaultFactory);
        console.log("\nRarity Probabilities:");
        console.log("  - Common (50%):", defaultConfig.rarityProbabilities[0]);
        console.log("  - Uncommon (40%):", defaultConfig.rarityProbabilities[1]);
        console.log("  - Rare (9%):", defaultConfig.rarityProbabilities[2]);
        console.log("  - Epic (0.9%):", defaultConfig.rarityProbabilities[3]);
        console.log("  - Legendary (0.1%):", defaultConfig.rarityProbabilities[4]);
        console.log("\nReward Bips:");
        console.log("  - Common: %s bips", defaultConfig.rarityRewardBips[0]);
        console.log("  - Uncommon: %s bips", defaultConfig.rarityRewardBips[1]);
        console.log("  - Rare: %s bips", defaultConfig.rarityRewardBips[2]);
        console.log("  - Epic: %s bips", defaultConfig.rarityRewardBips[3]);
        console.log("  - Legendary: %s bips", defaultConfig.rarityRewardBips[4]);

        vm.stopBroadcast();
    }
} 