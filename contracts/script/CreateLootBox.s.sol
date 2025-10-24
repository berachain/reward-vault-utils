// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {console2} from "forge-std/console2.sol";
import {Script} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract CreateLootBox is Script {
    // RewardVaultLootBox contract address from latest deployment
    RewardVaultLootBox public lootBoxVault = RewardVaultLootBox(0x894D26cf75816D137c62667613d0Ea0d8a1A9C64);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Generate a random number for this loot box
        bytes32 userRandomNumber = keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender));

        // Get the required fee using default provider
        uint256 fee = lootBoxVault.getEntropyFee();

        // Create the loot box
        uint64 sequenceNumber = lootBoxVault.createLootBox{value: fee}(userRandomNumber);
        console2.log("Created Loot Box with sequence number:", sequenceNumber);

        vm.stopBroadcast();
    }
}
