// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";
import {LootBox} from "../src/examples/LootBox.sol";

contract TestLootBoxBurn is Script {
    // Contract addresses from latest deployment
    address public constant REWARD_VAULT_LOOTBOX = 0x894D26cf75816D137c62667613d0Ea0d8a1A9C64;
    address public constant LOOTBOX = 0x891a2e459303DbEb5487a7f437142A70D5912dDe;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        RewardVaultLootBox lootBoxVault = RewardVaultLootBox(REWARD_VAULT_LOOTBOX);
        LootBox lootBox = LootBox(LOOTBOX);

        // Generate a random number for this loot box
        bytes32 userRandomNumber = keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender));
        
        // Get the required fee using default provider
        uint256 fee = lootBoxVault.getEntropyFee();
        
        // Create the loot box
        uint64 sequenceNumber = lootBoxVault.createLootBox{value: fee}(userRandomNumber);

        // Wait a bit for the entropy callback to process
        vm.warp(block.timestamp + 1);
        vm.roll(block.number + 1);

        // Check if the loot box was minted (token ID 1 if it's the first one)
        uint256 tokenId = 1;
        try lootBox.ownerOf(tokenId) returns (address owner) {
            // Get loot box item details
            LootBox.LootBoxItem memory item = lootBox.getLootBoxItem(tokenId);
            
            // Now open the loot box to test burn functionality
            lootBoxVault.openLootBox(tokenId);
            
            // Verify the NFT was burned by trying to get the owner
            try lootBox.ownerOf(tokenId) returns (address) {
                // NFT was not burned - this is an error
            } catch {
                // NFT was burned as expected
            }
            
        } catch {
            // Loot box NFT was not minted yet or doesn't exist
        }

        vm.stopBroadcast();
    }
} 