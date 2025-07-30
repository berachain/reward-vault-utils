// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MerkleManagerFactory} from "../src/utilities/MerkleManagerFactory.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";
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
        // Deploy the merkle manager setup
        (
            address manager,
            address rewardVaultToken,
            address fbgt,
            address liquidBGTMinter
        ) = factory.deployMerkleManager();

        // Verify all contracts were deployed
        assertTrue(manager != address(0), "Manager should be deployed");
        assertTrue(rewardVaultToken != address(0), "RewardVaultToken should be deployed");
        assertTrue(fbgt != address(0), "FBGT should be set");
        assertTrue(liquidBGTMinter != address(0), "LiquidBGTMinter should be set");

        // Verify ownership was transferred to the deployer
        RewardVaultManagerMerkle managerContract = RewardVaultManagerMerkle(manager);
        assertEq(managerContract.owner(), address(this), "Manager ownership should be transferred to deployer");
    }




} 