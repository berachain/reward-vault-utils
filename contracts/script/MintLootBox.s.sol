// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";
import {LootBox} from "../src/examples/LootBox.sol";

/// @notice Script to test minting a loot box using the deployed contracts
contract MintLootBox is Script {
    // Deployed contract addresses from the successful deployment
    address constant REWARD_VAULT_LOOTBOX = 0x9E6C05B895b069f8e9cd62d5Be591D1e7D50832c;
    address constant LOOTBOX = 0xF31B371a64275b73bCD161f55eD060C95bf9FEaD;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        console.log("=== Testing LootBox Minting ===");
        console.log("Deployer:", deployer);
        console.log("RewardVaultLootBox:", REWARD_VAULT_LOOTBOX);
        console.log("LootBox:", LOOTBOX);

        RewardVaultLootBox lootBoxVault = RewardVaultLootBox(REWARD_VAULT_LOOTBOX);
        LootBox lootBox = LootBox(LOOTBOX);

        // Check initial state
        console.log("\n=== Initial State ===");
        console.log("Deployer LootBox balance:", lootBox.balanceOf(deployer));
        console.log("Next token ID:", lootBox.nextTokenId());

        // Create a loot box for the deployer
        console.log("\n=== Creating LootBox ===");
        
        // Generate user random number
        bytes32 userRandomNumber = keccak256(abi.encodePacked(block.timestamp, deployer, "lootbox"));
        
        // Get the required fee
        uint256 fee = lootBoxVault.getFee();
        
        uint64 sequenceNumber = lootBoxVault.createLootBox{value: fee}(userRandomNumber);
        
        console.log("[SUCCESS] LootBox creation initiated with sequence number:", sequenceNumber);

        // Check final state
        console.log("\n=== Final State ===");
        console.log("Deployer LootBox balance:", lootBox.balanceOf(deployer));
        console.log("Next token ID:", lootBox.nextTokenId());
        
        // Get the token ID of the minted loot box (it will be nextTokenId - 1)
        uint256 tokenId = lootBox.nextTokenId() - 1;
        console.log("Minted token ID:", tokenId);
        
        // Check the owner of the token
        address tokenOwner = lootBox.ownerOf(tokenId);
        console.log("Token owner:", tokenOwner);
        
        // Get the loot box item details
        LootBox.LootBoxItem memory item = lootBox.getLootBoxItem(tokenId);
        console.log("LootBox rarity:", uint256(item.rarity));
        console.log("LootBox reward bips:", item.rewardBips);
        console.log("LootBox claimed:", item.claimed);

        console.log("\n=== LootBox Minting Test Complete ===");
        console.log("The deployer now owns a loot box NFT that can be opened for rewards!");

        vm.stopBroadcast();
    }
} 