// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract OpenLootBox is Script {
    // Contract addresses
    address constant REWARD_VAULT_LOOTBOX = 0x894D26cf75816D137c62667613d0Ea0d8a1A9C64;
    
    // Token ID 1 from the recent mint
    uint256 constant TOKEN_ID = 1;
    
    // Opener address from the mint transaction
    address constant OPENER = 0xC8B2FE82bc31e8b2aDA6514a3d4F3d2cA131e926;

    function run() external {
        // Use the opener's private key (this should be the deployer's private key)
        uint256 openerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(openerPrivateKey);

        RewardVaultLootBox lootBoxVault = RewardVaultLootBox(REWARD_VAULT_LOOTBOX);
        
        console.log("Opening loot box Token ID:", TOKEN_ID);
        console.log("Opener address:", OPENER);
        
        // Open the loot box
        lootBoxVault.openLootBox(TOKEN_ID);
        
        console.log("Loot box opened successfully!");
        
        vm.stopBroadcast();
    }
} 