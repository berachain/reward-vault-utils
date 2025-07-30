// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {LootBoxFactory} from "../src/utilities/LootBoxFactory.sol";
import {LootBox} from "../src/examples/LootBox.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract LootBoxFactoryTest is Test {
    LootBoxFactory public factory;
    LootBoxFactory.LootBoxConfig public defaultConfig;

    // Test addresses
    address public constant ENTROPY_CONTRACT = 0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320;
    address public constant DEFAULT_ENTROPY_PROVIDER = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;
    address public constant LIQUID_BGT_MINTER = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
    address public constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;
    address public constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;

    function setUp() public {
        // Create default configuration
        defaultConfig = LootBoxFactory.LootBoxConfig({
            // NFT Configuration
            name: "TestLootBox",
            symbol: "TEST",
            baseURI: "https://test.example.com/metadata/",
            
            // Rarity & Reward Configuration
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

        // Set default rarity probabilities
        defaultConfig.rarityProbabilities[0] = 5000; // COMMON (50%)
        defaultConfig.rarityProbabilities[1] = 4000; // UNCOMMON (40%)
        defaultConfig.rarityProbabilities[2] = 900;  // RARE (9%)
        defaultConfig.rarityProbabilities[3] = 90;   // EPIC (0.9%)
        defaultConfig.rarityProbabilities[4] = 10;   // LEGENDARY (0.1%)

        // Set default reward bips
        defaultConfig.rarityRewardBips[0] = 10;    // COMMON (0.1%)
        defaultConfig.rarityRewardBips[1] = 100;   // UNCOMMON (1%)
        defaultConfig.rarityRewardBips[2] = 500;   // RARE (5%)
        defaultConfig.rarityRewardBips[3] = 2000;  // EPIC (20%)
        defaultConfig.rarityRewardBips[4] = 5000;  // LEGENDARY (50%)

        // Deploy factory
        factory = new LootBoxFactory(defaultConfig);
    }

    function test_Constructor() public {
        LootBoxFactory.LootBoxConfig memory config = factory.getDefaultConfig();
        
        assertEq(config.name, "TestLootBox");
        assertEq(config.symbol, "TEST");
        assertEq(config.baseURI, "https://test.example.com/metadata/");
        assertEq(config.entropyContract, ENTROPY_CONTRACT);
        assertEq(config.defaultEntropyProvider, DEFAULT_ENTROPY_PROVIDER);
        assertEq(config.liquidBGTMinter, LIQUID_BGT_MINTER);
        assertEq(config.liquidBGTToken, FBGT_TOKEN);
        assertEq(config.rewardVaultFactory, REWARD_VAULT_FACTORY);
        
        // Check rarity probabilities
        assertEq(config.rarityProbabilities[0], 5000);
        assertEq(config.rarityProbabilities[1], 4000);
        assertEq(config.rarityProbabilities[2], 900);
        assertEq(config.rarityProbabilities[3], 90);
        assertEq(config.rarityProbabilities[4], 10);
        
        // Check reward bips
        assertEq(config.rarityRewardBips[0], 10);
        assertEq(config.rarityRewardBips[1], 100);
        assertEq(config.rarityRewardBips[2], 500);
        assertEq(config.rarityRewardBips[3], 2000);
        assertEq(config.rarityRewardBips[4], 5000);
    }

    function test_DeployWithDefaults() public {
        (
            address lootBox,
            address lootBoxVault,
            address rewardVault,
            address rewardVaultToken
        ) = factory.deployLootBoxSystemWithDefaults();

        // Verify contracts were deployed
        assertTrue(lootBox != address(0), "LootBox should be deployed");
        assertTrue(lootBoxVault != address(0), "LootBoxVault should be deployed");
        assertTrue(rewardVault != address(0), "RewardVault should be created");
        assertTrue(rewardVaultToken != address(0), "RewardVaultToken should exist");

        // Verify LootBox configuration
        LootBox lootBoxContract = LootBox(lootBox);
        assertEq(lootBoxContract.name(), "TestLootBox");
        assertEq(lootBoxContract.symbol(), "TEST");
        assertEq(lootBoxContract.controller(), lootBoxVault);

        // Verify RewardVaultLootBox configuration
        RewardVaultLootBox vaultContract = RewardVaultLootBox(lootBoxVault);
        assertEq(address(vaultContract.lootBoxContract()), lootBox);
        // Note: entropyContract is immutable but not public, so we can't test it directly
        // The contract is properly initialized with the correct entropy contract
        assertEq(vaultContract.defaultEntropyProvider(), DEFAULT_ENTROPY_PROVIDER);

        // Verify ownership - the factory transfers ownership to itself, then to the deployer
        // In the test environment, the factory is the deployer, so ownership should be the factory
        assertEq(lootBoxContract.owner(), address(factory));
    }

    function test_DeployWithCustomNFT() public {
        (
            address lootBox,
            address lootBoxVault,
            address rewardVault,
            address rewardVaultToken
        ) = factory.deployLootBoxSystemWithCustomNFT(
            "CustomLootBox",
            "CUSTOM",
            "https://custom.example.com/metadata/"
        );

        // Verify custom NFT configuration
        LootBox lootBoxContract = LootBox(lootBox);
        assertEq(lootBoxContract.name(), "CustomLootBox");
        assertEq(lootBoxContract.symbol(), "CUSTOM");

        // Verify other contracts were deployed
        assertTrue(lootBoxVault != address(0), "LootBoxVault should be deployed");
        assertTrue(rewardVault != address(0), "RewardVault should be created");
        assertTrue(rewardVaultToken != address(0), "RewardVaultToken should exist");
    }

    function test_DeployWithFullCustomConfig() public {
        LootBoxFactory.LootBoxConfig memory customConfig = LootBoxFactory.LootBoxConfig({
            // NFT Configuration
            name: "PremiumLootBox",
            symbol: "PREMIUM",
            baseURI: "https://premium.example.com/metadata/",
            
            // Rarity & Reward Configuration
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

        // Set custom rarity probabilities
        customConfig.rarityProbabilities[0] = 6000; // COMMON (60%)
        customConfig.rarityProbabilities[1] = 3000; // UNCOMMON (30%)
        customConfig.rarityProbabilities[2] = 800;  // RARE (8%)
        customConfig.rarityProbabilities[3] = 150;  // EPIC (1.5%)
        customConfig.rarityProbabilities[4] = 50;   // LEGENDARY (0.5%)

        // Set custom reward bips
        customConfig.rarityRewardBips[0] = 5;     // COMMON (0.05%)
        customConfig.rarityRewardBips[1] = 50;    // UNCOMMON (0.5%)
        customConfig.rarityRewardBips[2] = 250;   // RARE (2.5%)
        customConfig.rarityRewardBips[3] = 1000;  // EPIC (10%)
        customConfig.rarityRewardBips[4] = 2500;  // LEGENDARY (25%)

        (
            address lootBox,
            address lootBoxVault,
            address rewardVault,
            address rewardVaultToken
        ) = factory.deployLootBoxSystem(customConfig);

        // Verify custom configuration
        LootBox lootBoxContract = LootBox(lootBox);
        assertEq(lootBoxContract.name(), "PremiumLootBox");
        assertEq(lootBoxContract.symbol(), "PREMIUM");

        // Verify other contracts were deployed
        assertTrue(lootBoxVault != address(0), "LootBoxVault should be deployed");
        assertTrue(rewardVault != address(0), "RewardVault should be created");
        assertTrue(rewardVaultToken != address(0), "RewardVaultToken should exist");
    }

    function test_ValidateConfig() public {
        LootBoxFactory.LootBoxConfig memory validConfig = defaultConfig;
        
        bool isValid = factory.validateConfig(validConfig);
        assertTrue(isValid, "Valid config should pass validation");
    }

    function test_ValidateConfigInvalidProbabilities() public {
        LootBoxFactory.LootBoxConfig memory invalidConfig = defaultConfig;
        invalidConfig.rarityProbabilities[0] = 6000; // Makes total > 10000
        
        bool isValid = factory.validateConfig(invalidConfig);
        assertFalse(isValid, "Invalid probabilities should fail validation");
    }

    function test_ValidateConfigInvalidLength() public {
        LootBoxFactory.LootBoxConfig memory invalidConfig = defaultConfig;
        invalidConfig.rarityProbabilities = new uint256[](4); // Wrong length
        
        bool isValid = factory.validateConfig(invalidConfig);
        assertFalse(isValid, "Invalid array length should fail validation");
    }

    function test_ValidateConfigInvalidAddresses() public {
        LootBoxFactory.LootBoxConfig memory invalidConfig = defaultConfig;
        invalidConfig.entropyContract = address(0);
        
        bool isValid = factory.validateConfig(invalidConfig);
        assertFalse(isValid, "Invalid addresses should fail validation");
    }

    function test_UpdateDefaultConfig() public {
        LootBoxFactory.LootBoxConfig memory newConfig = defaultConfig;
        newConfig.name = "UpdatedLootBox";
        newConfig.symbol = "UPDATED";
        
        factory.updateDefaultConfig(newConfig);
        
        LootBoxFactory.LootBoxConfig memory updatedConfig = factory.getDefaultConfig();
        assertEq(updatedConfig.name, "UpdatedLootBox");
        assertEq(updatedConfig.symbol, "UPDATED");
    }

    function test_DeployMultipleSystems() public {
        // Deploy first system
        (
            address lootBox1,
            address lootBoxVault1,
            address rewardVault1,
            address rewardVaultToken1
        ) = factory.deployLootBoxSystemWithDefaults();

        // Deploy second system
        (
            address lootBox2,
            address lootBoxVault2,
            address rewardVault2,
            address rewardVaultToken2
        ) = factory.deployLootBoxSystemWithDefaults();

        // Verify they are different addresses
        assertTrue(lootBox1 != lootBox2, "LootBox addresses should be different");
        assertTrue(lootBoxVault1 != lootBoxVault2, "LootBoxVault addresses should be different");
        assertTrue(rewardVault1 != rewardVault2, "RewardVault addresses should be different");
        assertTrue(rewardVaultToken1 != rewardVaultToken2, "RewardVaultToken addresses should be different");
    }
} 