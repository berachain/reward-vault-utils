// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {BopIt} from "../src/examples/BopIt.sol";

contract DeployBopIt is Script {
    // Our Real-Time Manager (new address)
    address public constant REAL_TIME_MANAGER = 0x715b82419C055641E3B44C2b337850f3d8044B5F;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("RV_UTILS_PK");
        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying Bop It contract with new manager...");

        BopIt bopIt = new BopIt(REAL_TIME_MANAGER);

        console.log("Bop It deployed at:", address(bopIt));
        console.log("Connected to Real-Time Manager:", REAL_TIME_MANAGER);

        vm.stopBroadcast();
    }
}
