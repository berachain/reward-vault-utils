// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MerkleManagerFactory} from "../src/utilities/MerkleManagerFactory.sol";

contract DeployMerkleManagerFactory is Script {
    address private constant REWARD_VAULT_FACTORY = 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8;

    function run() external {
        // Use the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the MerkleManagerFactory
        MerkleManagerFactory factory = new MerkleManagerFactory(REWARD_VAULT_FACTORY);
        
        console.log("MerkleManagerFactory deployed at:", address(factory));
        console.log("RewardVaultFactory address:", REWARD_VAULT_FACTORY);

        vm.stopBroadcast();
    }
} 