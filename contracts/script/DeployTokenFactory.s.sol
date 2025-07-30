// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {TokenFactory} from "../src/utilities/TokenFactory.sol";

/// @title DeployTokenFactory
/// @notice Script to deploy the TokenFactory contract
contract DeployTokenFactory is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TokenFactory factory = new TokenFactory();
        
        console.log("TokenFactory deployed at:", address(factory));

        vm.stopBroadcast();
    }
} 