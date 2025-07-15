// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";
import {FBGT} from "../src/examples/FBGT.sol";

contract CreateAllocation is Script {
    bytes32 private constant CLAIM_ID = 0xdbfe098e934ba76bc305efe4e88740d64031faa3bc32eb20f0acc2095ff18b71;
    address private constant USER1 = 0x90783200B25740db5df651b866b6089f9D47F7cf;
    bytes32 private constant MERKLE_ROOT = 0x746371f265578c4e5bafa91380c80cab5b8c9e4126e7295e4a34077804d4b067;
    address private constant USER2 = 0xC8B2FE82bc31e8b2aDA6514a3d4F3d2cA131e926;
    uint256 private constant REWARD_AMOUNT = 1 ether;
    address private constant USER3 = 0x0d91683c12313d0a35A95Bb14a16bCAa208bf681;
    address private constant REWARD_VAULT_MANAGER = 0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3;
    address private constant FBGT_TOKEN = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        RewardVaultManagerMerkle manager = RewardVaultManagerMerkle(REWARD_VAULT_MANAGER);
        FBGT fbgt = FBGT(FBGT_TOKEN);

        console.log("Creating allocation...");
        manager.createAllocation(MERKLE_ROOT, REWARD_AMOUNT * 5, address(fbgt));
        console.log("Allocation created!");

        vm.stopBroadcast();
    }
}
