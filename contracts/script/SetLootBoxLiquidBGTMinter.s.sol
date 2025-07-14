// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract SetLootBoxLiquidBGTMinter is Script {
    // Contract addresses from successful deployment
    address constant REWARD_VAULT_LOOTBOX = 0xce63Ae8857C5608DbbD7089D873Dd681375db714;
    address constant LIQUID_BGT_MINTER = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
    address constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        RewardVaultLootBox lootBoxVault = RewardVaultLootBox(REWARD_VAULT_LOOTBOX);
        
        console.log("Setting liquid BGT minter and token on RewardVaultLootBox...");
        console.log("RewardVaultLootBox:", REWARD_VAULT_LOOTBOX);
        console.log("LiquidBGTMinter:", LIQUID_BGT_MINTER);
        console.log("FBGT Token:", FBGT_TOKEN);
        
        // Set the liquid BGT minter and token
        lootBoxVault.setLiquidBGTMinter(LIQUID_BGT_MINTER, FBGT_TOKEN);
        
        console.log("Liquid BGT minter and token set successfully!");
        console.log("The loot box system can now mint liquid BGT tokens for rewards.");

        vm.stopBroadcast();
    }
} 