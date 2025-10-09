// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Run this after sending FBGT to the RewardVaultLootBox contract.

import {Script} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract OpenLootBox is Script {
    address public constant REWARD_VAULT_LOOTBOX = 0x8f0E419112911F647917C1fa24842dA7D9e28FAD;
    uint256 public constant TOKEN_ID = 0;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        RewardVaultLootBox lootBoxVault = RewardVaultLootBox(REWARD_VAULT_LOOTBOX);
        lootBoxVault.openLootBox(TOKEN_ID);

        vm.stopBroadcast();
    }
}
