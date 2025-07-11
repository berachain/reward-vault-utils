// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";

contract CreateLootBox is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // RewardVaultLootBox contract address from latest deployment
        RewardVaultLootBox lootBoxVault = RewardVaultLootBox(0xeaEdF82472b59C1D24Bd107c3beb993724a8CDaa);
        
        // Deployer address (approved creator)
        address deployer = 0xC8B2FE82bc31e8b2aDA6514a3d4F3d2cA131e926;
        
        // Correct Pyth Entropy provider address for testnet
        address entropyProvider = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;
        
        // Generate a random number for testing
        bytes32 userRandomNumber = keccak256(abi.encodePacked(block.timestamp, deployer, "test"));
        
        // Fetch the correct entropy fee from the contract
        uint256 entropyFee = lootBoxVault.getFee(entropyProvider);
        console.log("Fetched entropy fee for berachain-bepolia:", entropyFee);
        
        console.log("Deployer:", deployer);
        console.log("Provider:", entropyProvider);
        console.log("User Random Number:", uint256(userRandomNumber));
        console.log("Entropy Fee:", entropyFee);
        
        // Create a loot box with the correct fee
        uint64 sequenceNumber = lootBoxVault.createLootBox{value: entropyFee}(entropyProvider, userRandomNumber);
        
        console.log("Loot box creation initiated with sequence number:", sequenceNumber);
        
        vm.stopBroadcast();
    }
} 