// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";

contract SetLiquidBGTMinter is Script {
    address constant REWARD_VAULT_MANAGER = 0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3;
    address constant MINTER = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
    address constant FBGT = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        RewardVaultManagerMerkle manager = RewardVaultManagerMerkle(REWARD_VAULT_MANAGER);
        console.log("Setting minter and FBGT token...");
        manager.setLiquidBGTMinter(MINTER, FBGT);
        console.log("SetLiquidBGTMinter complete!");

        vm.stopBroadcast();
    }
} 