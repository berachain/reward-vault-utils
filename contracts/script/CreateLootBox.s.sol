// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract CreateLootBox is Script {
    // RewardVaultLootBox contract address from latest deployment
    RewardVaultLootBox lootBoxVault = RewardVaultLootBox(0x894D26cf75816D137c62667613d0Ea0d8a1A9C64);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Pyth Entropy provider address
        address provider = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;
        
        // Generate a random number for this loot box
        bytes32 userRandomNumber = keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender));
        
        console.log("Creating loot box...");
        console.log("Provider:", provider);
        console.log("User random number:");
        console.logBytes32(userRandomNumber);
        
        // Get the required fee
        uint256 fee = lootBoxVault.getFee(provider);
        console.log("Required fee:", fee);
        
        // Create the loot box
        uint64 sequenceNumber = lootBoxVault.createLootBox{value: fee}(provider, userRandomNumber);
        console.log("Loot box creation initiated!");
        console.log("Sequence number:", sequenceNumber);

        vm.stopBroadcast();
    }
} 