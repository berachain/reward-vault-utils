// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract DeployRewardVaultLootBox is Script {
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

        // Probabilities from image: 50%, 40%, 9%, 0.9%, 0.1% (in bips)
        rarityProbabilities[0] = 5000; // No Prize
        rarityProbabilities[1] = 4000; // Common
        rarityProbabilities[2] = 900;  // Uncommon
        rarityProbabilities[3] = 90;   // Rare
        rarityProbabilities[4] = 10;   // Super Rare

        // Rewards from image (in BERA, but as bips for contract logic, example: 0, 0.1, 1, 5, 20 BERA)
        // These bips should be set according to your reward pool logic. Example below assumes 0, 0.1%, 1%, 5%, 20% of pool.
        rarityRewardBips[0] = 0;     // No Prize
        rarityRewardBips[1] = 10;    // Common (0.1%)
        rarityRewardBips[2] = 100;   // Uncommon (1%)
        rarityRewardBips[3] = 500;   // Rare (5%)
        rarityRewardBips[4] = 2000;  // Super Rare (20%)

        RewardVaultLootBox lootBox = new RewardVaultLootBox(
            entropyContract,
            name,
            symbol,
            baseURI,
            rarityProbabilities,
            rarityRewardBips
        );

        console.log("RewardVaultLootBox deployed at:", address(lootBox));

        vm.stopBroadcast();
    }
} 