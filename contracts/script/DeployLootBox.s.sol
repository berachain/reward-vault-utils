// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {LootBox} from "../src/examples/LootBox.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";
import {IRewardVaultFactory} from "../src/interfaces/IRewardVaultFactory.sol";

/// @notice Deploys the LootBox and RewardVaultLootBox contracts with full initialization.
/// @dev LootBox is now fully self-contained (no library dependencies).
contract DeployRewardVaultLootBox is Script {
    // Bepolia RewardVaultFactory address
    address public constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;

    // Existing deployed contracts on Bepolia
    address public constant LIQUID_BGT_MINTER = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
    address public constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Set actual entropy contract and provider addresses for Berachain Bepolia testnet
        address entropyContract = 0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320;
        address defaultProvider = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;
        string memory name = "LootBox";
        string memory symbol = "LOOT";
        string memory baseURI = "https://example.com/metadata/";
        uint256[] memory rarityProbabilities = new uint256[](5);
        uint256[] memory rarityRewardBips = new uint256[](5);

        // Probabilities: 50%, 40%, 9%, 0.9%, 0.1% (in bips)
        rarityProbabilities[0] = 5000; // COMMON (50%)
        rarityProbabilities[1] = 4000; // UNCOMMON (40%)
        rarityProbabilities[2] = 900; // RARE (9%)
        rarityProbabilities[3] = 90; // EPIC (0.9%)
        rarityProbabilities[4] = 10; // LEGENDARY (0.1%)

        // Reward bips for each rarity (basis points)
        rarityRewardBips[0] = 10; // COMMON (0.1%)
        rarityRewardBips[1] = 100; // UNCOMMON (1%)
        rarityRewardBips[2] = 500; // RARE (5%)
        rarityRewardBips[3] = 2000; // EPIC (20%)
        rarityRewardBips[4] = 5000; // LEGENDARY (50%)

        console.log("=== Deploying LootBox System ===");

        // 1. Deploy LootBox (now self-contained, no library dependencies)
        LootBox lootBox = new LootBox(name, symbol, baseURI); // controller will be set after deployment
        console.log("[SUCCESS] LootBox deployed at:", address(lootBox));

        // 2. Deploy RewardVaultLootBox with LootBox address and default provider
        RewardVaultLootBox lootBoxVault = new RewardVaultLootBox(
            entropyContract,
            address(lootBox),
            defaultProvider, // Use the correct default provider address
            rarityProbabilities,
            rarityRewardBips
        );
        console.log("[SUCCESS] RewardVaultLootBox deployed at:", address(lootBoxVault));

        // 3. Get the reward vault token from the loot box vault
        address rewardVaultToken = address(lootBoxVault.rewardVaultToken());
        console.log("[SUCCESS] RewardVaultToken:", rewardVaultToken);

        // 4. Deploy RewardVault using the factory
        address rewardVault = IRewardVaultFactory(REWARD_VAULT_FACTORY).createRewardVault(rewardVaultToken);
        console.log("[SUCCESS] RewardVault created at:", rewardVault);

        // 5. Register the reward vault with the loot box vault
        lootBoxVault.registerRewardVault(rewardVault);
        console.log("[SUCCESS] RewardVault registered with loot box vault");

        // 6. Set the controller of LootBox to RewardVaultLootBox
        lootBox.setController(address(lootBoxVault));
        console.log("[SUCCESS] LootBox controller set to:", lootBox.controller());

        // 7. Set the liquid BGT minter and token (using existing deployed contracts)
        console.log("=== Setting up Liquid BGT Integration ===");
        console.log("LiquidBGTMinter:", LIQUID_BGT_MINTER);
        console.log("FBGT Token:", FBGT_TOKEN);

        lootBoxVault.setLiquidBGTMinter(LIQUID_BGT_MINTER, FBGT_TOKEN);
        console.log("[SUCCESS] Liquid BGT minter and token set successfully");

        // 8. Set the deployer as an approved creator
        console.log("=== Setting up Creator Permissions ===");
        address deployer = vm.addr(deployerPrivateKey);
        lootBoxVault.setCreatorApproval(deployer, true);
        console.log("[SUCCESS] Deployer approved as creator:", deployer);

        console.log("\n=== Deployment Summary ===");
        console.log("LootBox NFT:", address(lootBox));
        console.log("RewardVaultLootBox:", address(lootBoxVault));
        console.log("RewardVault:", rewardVault);
        console.log("RewardVaultToken:", rewardVaultToken);
        console.log("Controller relationship established");
        console.log("Liquid BGT integration configured");
        console.log("Creator permissions set");
        console.log("\nLootBox system is ready to use!");

        // Test the loot box creation flow
        console.log("\n=== Testing Loot Box Creation ===");

        // Generate a random number for the test loot box
        bytes32 userRandomNumber = keccak256(abi.encodePacked(block.timestamp, deployer, "deployment-test"));

        // Get the required fee
        uint256 fee = lootBoxVault.getEntropyFee();
        console.log("Required fee for loot box creation:", fee);

        // Create the loot box
        uint64 sequenceNumber = lootBoxVault.createLootBox{value: fee}(userRandomNumber);
        console.log("Loot box creation initiated with sequence number:", sequenceNumber);

        // Wait a bit for the entropy callback to process (simulate time passing)
        vm.warp(block.timestamp + 1);
        vm.roll(block.number + 1);

        // NOTE: Loot box NFT minting is asynchronous and depends on the Pyth entropy callback.
        // To check the NFT, use a follow-up script or check manually after a few blocks.
        // (Removed underflow-prone nextTokenId - 1 check)

        vm.stopBroadcast();
    }
}
