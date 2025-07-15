// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract SetCreatorApproval is Script {
    // RewardVaultLootBox contract address from latest deployment
    RewardVaultLootBox lootBoxVault = RewardVaultLootBox(0x894D26cf75816D137c62667613d0Ea0d8a1A9C64);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Get the deployer address
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Setting creator approval for:", deployer);

        // Set creator approval to true
        lootBoxVault.setCreatorApproval(deployer, true);
        console.log("Creator approval set successfully!");

        vm.stopBroadcast();
    }
} 