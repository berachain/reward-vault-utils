// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract SetLootBoxLiquidBGTToken is Script {
    // Contract addresses from successful deployment
    address constant REWARD_VAULT_LOOTBOX = 0xce63Ae8857C5608DbbD7089D873Dd681375db714;
    address constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        RewardVaultLootBox lootBoxVault = RewardVaultLootBox(REWARD_VAULT_LOOTBOX);
        
        console.log("Setting liquid BGT token on RewardVaultLootBox...");
        console.log("RewardVaultLootBox:", REWARD_VAULT_LOOTBOX);
        console.log("FBGT Token:", FBGT_TOKEN);
        
        // Set the liquid BGT token directly
        lootBoxVault.setLiquidBGTToken(FBGT_TOKEN);
        
        console.log("Liquid BGT token set successfully!");
        console.log("The loot box system can now use FBGT tokens for rewards.");

        vm.stopBroadcast();
    }
} 