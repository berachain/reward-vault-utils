// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {TokenFactory} from "../src/utilities/TokenFactory.sol";

/// @notice Deploys TokenFactory contract using RV_UTILS_PK
/// @dev Deploys TokenFactory for creating ERC20 tokens
contract DeployTokenFactory is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("RV_UTILS_PK");
        vm.startBroadcast(deployerPrivateKey);

        console.log("=== Deploying TokenFactory with RV_UTILS_PK ===");

        // Deploy TokenFactory
        console.log("\n--- Deploying TokenFactory ---");
        TokenFactory tokenFactory = new TokenFactory();
        console.log("TokenFactory deployed at:", address(tokenFactory));

        console.log("\n=== Deployment Summary ===");
        console.log("TokenFactory:", address(tokenFactory));
        console.log("\nTokenFactory deployed successfully!");

        vm.stopBroadcast();
    }
}
