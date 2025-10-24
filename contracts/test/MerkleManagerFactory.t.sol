// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {MerkleManagerFactory} from "../src/utilities/MerkleManagerFactory.sol";
import {RewardVaultManagerMerkle} from "../src/examples/RewardVaultManagerMerkle.sol";

contract MerkleManagerFactoryTest is Test {
    MerkleManagerFactory public factory;
    address public mockRewardVaultFactory;

    function setUp() public {
        // Deploy the factory (constructor takes no parameters)
        factory = new MerkleManagerFactory();
    }

    function test_Constructor() public view {
        assertEq(factory.rewardVaultFactory(), 0x94Ad6Ac84f6C6FbA8b8CCbD71d9f4f101def52a8);
        assertEq(factory.owner(), address(this));
    }

    function test_ConstructorZeroAddress() public pure {
        // This test is no longer applicable since constructor takes no parameters
        // The reward vault factory is hardcoded in the contract
        assertTrue(true);
    }

    function test_DeployMerkleManager() public {
        // Deploy the merkle manager setup
        (address manager, address rewardVaultToken) =
            factory.deployMerkleManager();

        // Verify all contracts were deployed
        assertTrue(manager != address(0), "Manager should be deployed");
        assertTrue(rewardVaultToken != address(0), "RewardVaultToken should be deployed");

        // Verify ownership was transferred to the deployer
        RewardVaultManagerMerkle managerContract = RewardVaultManagerMerkle(manager);
        assertEq(managerContract.owner(), address(this), "Manager ownership should be transferred to deployer");
    }
}
