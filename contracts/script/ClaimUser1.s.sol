// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";

contract ClaimUser1 is Script {
    address constant REWARD_VAULT_MANAGER = 0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3;
    bytes32 constant MERKLE_ROOT = 0x746371f265578c4e5bafa91380c80cab5b8c9e4126e7295e4a34077804d4b067;
    bytes32 constant CLAIM_ID = 0xdbfe098e934ba76bc305efe4e88740d64031faa3bc32eb20f0acc2095ff18b71;
    address constant FBGT = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;
    address constant USER1 = 0x90783200B25740db5df651b866b6089f9D47F7cf;
    uint256 constant REWARD_AMOUNT = 1 ether;

    function run() external {
        bytes32[] memory proof = new bytes32[](3);
        proof[0] = 0x8071280603eaf946a36d10d91b84501094a28e9e657fd7f927a4c2c5e3938292;
        proof[1] = 0x273dc9ff8a02be63f9562737b4bd0f800140eefadb32c9588b3f1921d3c21557;
        proof[2] = 0xad1f799a010f8b47d780b24d903ce6687048726ea8a5f65c4eac6fadb99f49ae;

        uint256 user1PrivateKey = vm.envUint("USER1_PRIVATE_KEY");
        vm.startBroadcast(user1PrivateKey);

        RewardVaultManagerMerkle manager = RewardVaultManagerMerkle(REWARD_VAULT_MANAGER);
        console.log("Claiming for user 1...");
        manager.claim(MERKLE_ROOT, CLAIM_ID, FBGT, REWARD_AMOUNT, proof);
        console.log("Claim complete!");

        vm.stopBroadcast();
    }
} 