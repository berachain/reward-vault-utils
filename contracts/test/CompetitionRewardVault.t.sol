// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {CompetitionRewardVault} from "../src/CompetitionRewardVault.sol";
import {CompetitionToken} from "../src/CompetitionToken.sol";
import {IRewardVault} from "@berachain/contracts/src/rewards/IRewardVault.sol";
import {MerkleProofLib} from "@solady/utils/MerkleProofLib.sol";

contract MockRewardVault is IRewardVault {
    mapping(address => uint256) public earned;
    address public stakingToken;

    constructor(address _stakingToken) {
        stakingToken = _stakingToken;
    }

    function setEarned(address account, uint256 amount) external {
        earned[account] = amount;
    }

    function getReward(address account, address recipient) external {
        uint256 amount = earned[account];
        earned[account] = 0;
        // In a real test, we would transfer tokens here
    }

    // Implement other required interface functions
    function stake(uint256 amount) external {}
    function withdraw(uint256 amount) external {}
    function exit() external {}
}

contract CompetitionRewardVaultTest is Test {
    CompetitionRewardVault public vault;
    CompetitionToken public competitionToken;
    MockRewardVault public rewardVault;
    address public bgtToken;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        bgtToken = makeAddr("bgtToken");

        // Deploy competition token
        competitionToken = new CompetitionToken("Competition Token", "CT", 18);
        
        // Deploy mock reward vault
        rewardVault = new MockRewardVault(address(competitionToken));
        
        // Deploy vault
        vm.startPrank(owner);
        vault = new CompetitionRewardVault(address(rewardVault), bgtToken);
        
        // Transfer ownership of competition token to vault
        competitionToken.transferOwnership(address(vault));
        vm.stopPrank();
    }

    function test_CreateDistribution() public {
        uint256 distributionId = 1;
        bytes32 merkleRoot = bytes32(uint256(1));
        uint256 amount = 1000;

        vm.startPrank(owner);
        vault.createDistribution(distributionId, merkleRoot, amount);
        vm.stopPrank();

        (bytes32 root, uint256 distAmount, bool isActive) = vault.getDistributionInfo(distributionId);
        assertEq(root, merkleRoot);
        assertEq(distAmount, amount);
        assertTrue(isActive);
    }

    function test_ClaimReward() public {
        uint256 distributionId = 1;
        uint256 amount = 1000;
        bytes32 merkleRoot = bytes32(uint256(1));
        
        // Set up earned rewards in mock vault
        rewardVault.setEarned(address(vault), amount);

        // Create distribution
        vm.startPrank(owner);
        vault.createDistribution(distributionId, merkleRoot, amount);
        vm.stopPrank();

        // Generate merkle proof (in a real test, we would use a proper merkle tree)
        bytes32[] memory proof = new bytes32[](0);
        bytes32 leaf = keccak256(abi.encodePacked(distributionId, user1, amount));

        // Claim reward
        vm.startPrank(user1);
        vault.claimReward(distributionId, amount, proof);
        vm.stopPrank();

        // Verify claim status
        assertTrue(vault.hasClaimed(distributionId, user1));
    }

    function testFail_DoubleClaim() public {
        uint256 distributionId = 1;
        uint256 amount = 1000;
        bytes32 merkleRoot = bytes32(uint256(1));
        
        // Set up earned rewards in mock vault
        rewardVault.setEarned(address(vault), amount);

        // Create distribution
        vm.startPrank(owner);
        vault.createDistribution(distributionId, merkleRoot, amount);
        vm.stopPrank();

        // Generate merkle proof
        bytes32[] memory proof = new bytes32[](0);
        bytes32 leaf = keccak256(abi.encodePacked(distributionId, user1, amount));

        // First claim
        vm.startPrank(user1);
        vault.claimReward(distributionId, amount, proof);
        
        // Second claim should fail
        vault.claimReward(distributionId, amount, proof);
        vm.stopPrank();
    }

    function test_GetEarnedBGT() public {
        uint256 distributionId = 1;
        uint256 amount = 1000;
        bytes32 merkleRoot = bytes32(uint256(1));
        
        // Create distribution
        vm.startPrank(owner);
        vault.createDistribution(distributionId, merkleRoot, amount);
        vm.stopPrank();

        // Generate merkle proof
        bytes32[] memory proof = new bytes32[](0);
        bytes32 leaf = keccak256(abi.encodePacked(distributionId, user1, amount));

        // Verify earned BGT
        bool isValid = vault.getEarnedBGT(distributionId, user1, amount, proof);
        assertTrue(isValid);
    }
} 