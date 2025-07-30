// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MerkleManagerFactory} from "../src/utilities/MerkleManagerFactory.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";
import {FBGT} from "../src/examples/FBGT.sol";
import {LiquidBGTMinter} from "../src/examples/LiquidBGTMinter.sol";
import {IRewardVaultFactory} from "../src/interfaces/IRewardVaultFactory.sol";

contract MerkleManagerFactoryTest is Test {
    MerkleManagerFactory public factory;
    address public mockRewardVaultFactory;

    function setUp() public {
        // Deploy a mock reward vault factory
        mockRewardVaultFactory = address(0x123);
        
        // Deploy the factory
        factory = new MerkleManagerFactory(mockRewardVaultFactory);
    }

    function test_Constructor() public {
        assertEq(factory.rewardVaultFactory(), mockRewardVaultFactory);
        assertEq(factory.owner(), address(this));
    }

    function test_ConstructorZeroAddress() public {
        vm.expectRevert(MerkleManagerFactory.ZeroRewardVaultFactory.selector);
        new MerkleManagerFactory(address(0));
    }

    function test_DeployMerkleManager() public {
        // Mock the reward vault factory to return a valid address
        vm.mockCall(
            mockRewardVaultFactory,
            abi.encodeWithSelector(IRewardVaultFactory.createRewardVault.selector),
            abi.encode(address(0x456))
        );

        // Deploy the merkle manager setup
        (
            address manager,
            address rewardVault,
            address fbgt,
            address liquidBGTMinter,
            address rewardVaultToken
        ) = factory.deployMerkleManager();

        // Verify all contracts were deployed
        assertTrue(manager != address(0), "Manager should be deployed");
        assertTrue(rewardVault != address(0), "RewardVault should be deployed");
        assertTrue(fbgt != address(0), "FBGT should be deployed");
        assertTrue(liquidBGTMinter != address(0), "LiquidBGTMinter should be deployed");
        assertTrue(rewardVaultToken != address(0), "RewardVaultToken should be deployed");

        // Verify the manager is initialized
        RewardVaultManagerMerkle managerContract = RewardVaultManagerMerkle(manager);
        assertTrue(managerContract.initialized(), "Manager should be initialized");

        // Verify FBGT ownership was transferred
        FBGT fbgtContract = FBGT(fbgt);
        assertEq(fbgtContract.owner(), liquidBGTMinter, "FBGT ownership should be transferred to minter");
    }

    function test_DeployMerkleManagerDefault() public {
        // Mock the reward vault factory to return a valid address
        vm.mockCall(
            mockRewardVaultFactory,
            abi.encodeWithSelector(IRewardVaultFactory.createRewardVault.selector),
            abi.encode(address(0x456))
        );

        // Deploy the merkle manager setup using default function
        (
            address manager,
            address rewardVault,
            address fbgt,
            address liquidBGTMinter,
            address rewardVaultToken
        ) = factory.deployMerkleManagerDefault();

        // Verify all contracts were deployed
        assertTrue(manager != address(0), "Manager should be deployed");
        assertTrue(rewardVault != address(0), "RewardVault should be deployed");
        assertTrue(fbgt != address(0), "FBGT should be deployed");
        assertTrue(liquidBGTMinter != address(0), "LiquidBGTMinter should be deployed");
        assertTrue(rewardVaultToken != address(0), "RewardVaultToken should be deployed");
    }

    function test_RewardVaultCreationFailure() public {
        // Mock the reward vault factory to revert
        vm.mockCallRevert(
            mockRewardVaultFactory,
            abi.encodeWithSelector(IRewardVaultFactory.createRewardVault.selector),
            "RewardVault creation failed"
        );

        // Expect the deployment to revert
        vm.expectRevert(MerkleManagerFactory.RewardVaultCreationFailed.selector);
        factory.deployMerkleManager();
    }
} 