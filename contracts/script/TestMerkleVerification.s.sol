// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
// import {console} from "forge-std/console.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";

contract TestMerkleVerification is Script {
    address constant REWARD_VAULT_MANAGER = 0x9f6A372c6f391FB1E1A7C078004BC489212bdEa3;
    address constant FBGT = 0x4ed091c61ddb2b2Dc69D057284791FeD9d640ece;
    address constant USER1 = 0x90783200B25740db5df651b866b6089f9D47F7cf;

    bytes32 constant MERKLE_ROOT = 0xa7e4302337c994651985cdcfb9dda5d11e692b3d5aa40d4b3d2de1142afbd746;
    bytes32 constant CLAIM_ID = 0xe8905b07b47d23e8fabf372532501403b78f9d65423179394d338f1cdb34ded0;
    uint256 constant AMOUNT = 1e18;

    function run() external {
        bytes32[] memory proof = new bytes32[](3);
        proof[0] = 0xbcdc6d7567d2f310309191f7f58e7a0207072600064cf4b34b539c380a0a6303;
        proof[1] = 0xde618df0944a63e4e16d53e6dfccfba0c1760df4797a427af0864df436e66263;
        proof[2] = 0xd729c259509a584e06adf9df90888b67cac593b7dfe8e16448d75f26dffe1332;

        // console.log("Testing allocation creation...");
        // console.log("ClaimId:");
        // console.logBytes32(CLAIM_ID);
        // console.log("MerkleRoot:");
        // console.logBytes32(MERKLE_ROOT);
        // console.log("PrizeAmount:");
        // console.log(5e18);

        // Create allocation as owner
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        RewardVaultManagerMerkle manager = RewardVaultManagerMerkle(REWARD_VAULT_MANAGER);
        manager.createAllocation(MERKLE_ROOT, 5e18, FBGT);
        // console.log("Allocation created successfully!");
        vm.stopBroadcast();

        // console.log("\nTesting claim for user1...");
        // console.log("User:");
        // console.log(USER1);
        // console.log("RewardAmount:");
        // console.log(AMOUNT);
        // console.log("Proof length:");
        // console.log(proof.length);

        // Claim as user1
        vm.startBroadcast(vm.envUint("USER1_PRIVATE_KEY"));
        manager.claim(MERKLE_ROOT, CLAIM_ID, FBGT, AMOUNT, proof);
        // console.log("Claim verified successfully!");
        vm.stopBroadcast();
    }
} 