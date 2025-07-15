// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {LootBox} from "../src/examples/LootBox.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";
import {IRewardVaultFactory} from "../src/interfaces/IRewardVaultFactory.sol";

contract DeployRewardVaultLootBox is Script {
    // Bepolia RewardVaultFactory address
    address constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Set actual entropy contract address
        address entropyContract = 0x36825bf3Fbdf5a29E2d5148bfe7Dcf7B5639e320;
        string memory name = "LootBox";
        string memory symbol = "LOOT";
        string memory baseURI = "https://example.com/metadata/";
        uint256[] memory rarityProbabilities = new uint256[](5);
        uint256[] memory rarityRewardBips = new uint256[](5);

        // Probabilities: 50%, 40%, 9%, 0.9%, 0.1% (in bips)
        rarityProbabilities[0] = 5000; // COMMON (50%)
        rarityProbabilities[1] = 4000; // UNCOMMON (40%)
        rarityProbabilities[2] = 900;  // RARE (9%)
        rarityProbabilities[3] = 90;   // EPIC (0.9%)
        rarityProbabilities[4] = 10;   // LEGENDARY (0.1%)

        // Reward bips for each rarity (basis points)
        rarityRewardBips[0] = 10;    // COMMON (0.1%)
        rarityRewardBips[1] = 100;   // UNCOMMON (1%)
        rarityRewardBips[2] = 500;   // RARE (5%)
        rarityRewardBips[3] = 2000;  // EPIC (20%)
        rarityRewardBips[4] = 5000;  // LEGENDARY (50%)

        // 1. Deploy LootBox first
        LootBox lootBox = new LootBox(name, symbol, baseURI, address(0)); // controller will be set after deployment
        console.log("LootBox deployed at:", address(lootBox));

        // 2. Deploy RewardVaultLootBox with LootBox address
        RewardVaultLootBox lootBoxVault = new RewardVaultLootBox(
            entropyContract,
            address(lootBox),
            rarityProbabilities,
            rarityRewardBips
        );
        console.log("RewardVaultLootBox deployed at:", address(lootBoxVault));

        // 3. Get the reward vault token from the loot box vault
        address rewardVaultToken = address(lootBoxVault.rewardVaultToken());
        console.log("RewardVaultToken:", rewardVaultToken);

        // 4. Deploy RewardVault using the factory
        address rewardVault = IRewardVaultFactory(REWARD_VAULT_FACTORY).createRewardVault(rewardVaultToken);
        console.log("RewardVault created at:", rewardVault);

        // 5. Register the reward vault with the loot box vault
        lootBoxVault.registerRewardVault(rewardVault);
        console.log("RewardVault registered with loot box vault");

        // 6. Set the controller of LootBox to RewardVaultLootBox
        lootBox.setController(address(lootBoxVault));
        console.log("LootBox controller set to:", lootBox.controller());

        // 7. Set the liquid BGT minter and token (using existing deployed contracts)
        address liquidBGTMinter = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
        address fbgtToken = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;
        lootBoxVault.setLiquidBGTMinter(liquidBGTMinter, fbgtToken);
        console.log("Liquid BGT minter and token set:");
        console.log("  - Minter:", liquidBGTMinter);
        console.log("  - Token:", fbgtToken);

        vm.stopBroadcast();
    }
} 