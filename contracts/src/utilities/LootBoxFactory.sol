// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {LootBox} from "../examples/LootBox.sol";
import {RewardVaultLootBox} from "../examples/RewardVaultLootBox.sol";
import {IRewardVaultFactory} from "../interfaces/IRewardVaultFactory.sol";

/// @title LootBoxFactory
/// @notice Factory contract for deploying complete loot box systems with configurable parameters
/// @dev Designed for interactive UI deployment with sensible defaults and customization options
contract LootBoxFactory {
    // ============ Events ============

    /// @notice Emitted when a loot box system is deployed
    /// @param lootBox The address of the deployed LootBox NFT contract
    /// @param lootBoxVault The address of the deployed RewardVaultLootBox contract
    /// @param rewardVault The address of the created RewardVault
    /// @param rewardVaultToken The address of the RewardVaultToken
    /// @param deployer The address that deployed the system
    /// @param config The configuration used for deployment
    event LootBoxSystemDeployed(
        address indexed lootBox,
        address indexed lootBoxVault,
        address indexed rewardVault,
        address rewardVaultToken,
        address deployer,
        LootBoxConfig config
    );

    // ============ Structs ============

    /// @notice Configuration for loot box system deployment
    /// @dev Designed for UI-friendly parameter passing
    struct LootBoxConfig {
        // NFT Configuration
        string name;
        string symbol;
        string baseURI;
        
        // Rarity & Reward Configuration (5 values for 5 rarities)
        uint256[] rarityProbabilities;  // Basis points (10000 = 100%)
        uint256[] rarityRewardBips;     // Reward basis points
        
        // Entropy Configuration
        address entropyContract;
        address defaultEntropyProvider;
        
        // Integration Configuration
        address liquidBGTMinter;
        address liquidBGTToken;
        address rewardVaultFactory;
    }

    // ============ State Variables ============

    /// @notice Default configuration values for quick deployment
    LootBoxConfig public defaultConfig;

    // ============ Constructor ============

    /// @notice Creates a new LootBoxFactory with default configuration
    /// @param _defaultConfig The default configuration to use for quick deployments
    constructor(LootBoxConfig memory _defaultConfig) {
        defaultConfig = _defaultConfig;
    }

    // ============ External Functions ============

    /// @notice Deploy a loot box system with custom configuration
    /// @param config The configuration for the loot box system
    /// @return lootBox The address of the deployed LootBox NFT contract
    /// @return lootBoxVault The address of the deployed RewardVaultLootBox contract
    /// @return rewardVault The address of the created RewardVault
    /// @return rewardVaultToken The address of the RewardVaultToken
    function deployLootBoxSystem(LootBoxConfig memory config) 
        external 
        returns (
            address lootBox,
            address lootBoxVault,
            address rewardVault,
            address rewardVaultToken
        ) 
    {
        // Validate configuration
        validateConfigInternal(config);

        // Deploy LootBox NFT contract
        lootBox = address(new LootBox(
            config.name,
            config.symbol,
            config.baseURI,
            address(0) // Controller will be set after deployment
        ));

        // Deploy RewardVaultLootBox
        lootBoxVault = address(new RewardVaultLootBox(
            config.entropyContract,
            lootBox,
            config.defaultEntropyProvider,
            config.rarityProbabilities,
            config.rarityRewardBips
        ));

        // Get reward vault token from loot box vault
        rewardVaultToken = address(RewardVaultLootBox(lootBoxVault).rewardVaultToken());

        // Create RewardVault using factory
        rewardVault = IRewardVaultFactory(config.rewardVaultFactory).createRewardVault(rewardVaultToken);

        // Register reward vault with loot box vault
        RewardVaultLootBox(lootBoxVault).registerRewardVault(rewardVault);

        // Set controller relationship
        LootBox(lootBox).setController(lootBoxVault);

        // Set up liquid BGT integration
        RewardVaultLootBox(lootBoxVault).setLiquidBGTMinter(
            config.liquidBGTMinter,
            config.liquidBGTToken
        );

        // Set deployer as approved creator
        RewardVaultLootBox(lootBoxVault).setCreatorApproval(msg.sender, true);

        // Transfer ownership of loot box to deployer
        LootBox(lootBox).transferOwnership(msg.sender);

        emit LootBoxSystemDeployed(
            lootBox,
            lootBoxVault,
            rewardVault,
            rewardVaultToken,
            msg.sender,
            config
        );
    }

    /// @notice Deploy a loot box system using default configuration
    /// @return lootBox The address of the deployed LootBox NFT contract
    /// @return lootBoxVault The address of the deployed RewardVaultLootBox contract
    /// @return rewardVault The address of the created RewardVault
    /// @return rewardVaultToken The address of the RewardVaultToken
    function deployLootBoxSystemWithDefaults() 
        external 
        returns (
            address lootBox,
            address lootBoxVault,
            address rewardVault,
            address rewardVaultToken
        ) 
    {
        return this.deployLootBoxSystem(defaultConfig);
    }

    /// @notice Deploy a loot box system with custom NFT settings but default game mechanics
    /// @param name The name of the loot box NFT collection
    /// @param symbol The symbol of the loot box NFT collection
    /// @param baseURI The base URI for NFT metadata
    /// @return lootBox The address of the deployed LootBox NFT contract
    /// @return lootBoxVault The address of the deployed RewardVaultLootBox contract
    /// @return rewardVault The address of the created RewardVault
    /// @return rewardVaultToken The address of the RewardVaultToken
    function deployLootBoxSystemWithCustomNFT(
        string memory name,
        string memory symbol,
        string memory baseURI
    ) 
        external 
        returns (
            address lootBox,
            address lootBoxVault,
            address rewardVault,
            address rewardVaultToken
        ) 
    {
        LootBoxConfig memory config = defaultConfig;
        config.name = name;
        config.symbol = symbol;
        config.baseURI = baseURI;
        
        return this.deployLootBoxSystem(config);
    }

    /// @notice Update the default configuration
    /// @param newConfig The new default configuration
    function updateDefaultConfig(LootBoxConfig memory newConfig) external {
        validateConfigInternal(newConfig);
        defaultConfig = newConfig;
    }

    // ============ View Functions ============

    /// @notice Get the current default configuration
    /// @return The default configuration struct
    function getDefaultConfig() external view returns (LootBoxConfig memory) {
        return defaultConfig;
    }

    /// @notice Validate a configuration without deploying
    /// @param config The configuration to validate
    /// @return isValid Whether the configuration is valid
    function validateConfig(LootBoxConfig memory config) external view returns (bool isValid) {
        try this.validateConfigInternal(config) {
            return true;
        } catch {
            return false;
        }
    }

    // ============ Internal Functions ============

    /// @notice Validate configuration parameters
    /// @param config The configuration to validate
    function validateConfigInternal(LootBoxConfig memory config) public pure {
        // Validate array lengths
        require(config.rarityProbabilities.length == 5, "Invalid prob length");
        require(config.rarityRewardBips.length == 5, "Invalid reward length");
        
        // Validate probabilities sum to 100%
        uint256 totalProbability = 0;
        for (uint256 i = 0; i < 5; i++) {
            totalProbability += config.rarityProbabilities[i];
        }
        require(totalProbability == 10000, "Probabilities must sum to 10000 bips");
        
        // Validate addresses
        require(config.entropyContract != address(0), "Invalid entropy contract");
        require(config.defaultEntropyProvider != address(0), "Invalid entropy provider");
        require(config.liquidBGTMinter != address(0), "Invalid liquid BGT minter");
        require(config.liquidBGTToken != address(0), "Invalid liquid BGT token");
        require(config.rewardVaultFactory != address(0), "Invalid reward vault factory");
        
        // Validate strings
        require(bytes(config.name).length > 0, "Empty name");
        require(bytes(config.symbol).length > 0, "Empty symbol");
    }
} 