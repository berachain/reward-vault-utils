// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FBGTFaucet} from "../src/utilities/FBGTFaucet.sol";

/// @notice Deploys the FBGT faucet contract
contract DeployFBGTFaucet is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("=== Deploying FBGT Faucet ===");

        // FBGT token address on Berachain Bepolia
        address fbgtToken = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

        console.log("FBGT Token Address:", fbgtToken);

        // Deploy FBGTFaucet
        console.log("\n--- Deploying FBGTFaucet ---");
        FBGTFaucet faucet = new FBGTFaucet(fbgtToken);
        console.log("FBGTFaucet deployed at:", address(faucet));

        // Test the faucet
        console.log("\n--- Testing Faucet Functions ---");
        console.log("Faucet Balance:", faucet.getFaucetBalance());
        console.log("FBGT Address:", faucet.getFBGTAddress());

        console.log("\n=== Deployment Summary ===");
        console.log("FBGTFaucet:", address(faucet));
        console.log("FBGT Token:", fbgtToken);
        console.log("Owner:", msg.sender);
        console.log("Faucet deployed successfully!");

        vm.stopBroadcast();
    }
} 