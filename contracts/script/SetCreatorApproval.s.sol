// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract SetCreatorApproval is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // RewardVaultLootBox contract address from latest deployment
        RewardVaultLootBox lootBoxVault = RewardVaultLootBox(0xeaEdF82472b59C1D24Bd107c3beb993724a8CDaa);
        
        // Deployer address from deployment
        address deployer = 0xC8B2FE82bc31e8b2aDA6514a3d4F3d2cA131e926;
        
        // Set the deployer as an approved creator
        lootBoxVault.setCreatorApproval(deployer, true);
        
        console.log("Creator approval set for:", deployer);
        console.log("Contract address:", address(lootBoxVault));
        
        vm.stopBroadcast();
    }
} 