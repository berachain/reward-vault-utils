// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {BopIt} from "../src/examples/BopIt.sol";
import {RewardVaultManagerRealTime} from "../src/examples/RewardVaultManagerRealTime.sol";

contract BopItTest is Test {
    BopIt public bopIt;
    RewardVaultManagerRealTime public manager;

    address public owner = address(this);
    address public player = address(0x123);

    function setUp() public {
        // Deploy manager
        manager = new RewardVaultManagerRealTime();

        // Deploy Bop It
        bopIt = new BopIt(address(manager));

        // Whitelist the Bop It contract as a distributor
        manager.setDistributorWhitelist(address(bopIt), true);
    }

    function test_Constructor() public {
        assertEq(address(bopIt.rewardManager()), address(manager));
        assertEq(bopIt.owner(), owner);
    }

    function test_BopAction() public {
        vm.prank(player);
        bopIt.bop();

        assertEq(bopIt.lastBopTime(player), block.timestamp);
    }

    function test_BopCooldown() public {
        vm.prank(player);
        bopIt.bop();

        // Try to bop again immediately
        vm.prank(player);
        vm.expectRevert("Bop cooldown not met");
        bopIt.bop();

        // Wait for cooldown and try again
        vm.warp(block.timestamp + 31);
        vm.prank(player);
        bopIt.bop();
    }

    function test_TwistAction() public {
        vm.prank(player);
        bopIt.twist();

        assertEq(bopIt.lastTwistTime(player), block.timestamp);
    }

    function test_PullAction() public {
        vm.prank(player);
        bopIt.pull();

        assertEq(bopIt.lastPullTime(player), block.timestamp);
    }

    function test_SpinAction() public {
        vm.prank(player);
        bopIt.spin();

        assertEq(bopIt.lastSpinTime(player), block.timestamp);
    }

    function test_FlickAction() public {
        vm.prank(player);
        bopIt.flick();

        assertEq(bopIt.lastFlickTime(player), block.timestamp);
    }

    function test_CooldownRemaining() public {
        address freshPlayer = address(0x999);

        // Initially no cooldown (should be 0 if never used)
        uint256 initialCooldown = bopIt.getBopCooldownRemaining(freshPlayer);
        assertEq(initialCooldown, 0);

        // Perform action
        vm.prank(freshPlayer);
        bopIt.bop();

        // Check cooldown remaining
        assertEq(bopIt.getBopCooldownRemaining(freshPlayer), 30);

        // Wait half the cooldown
        vm.warp(block.timestamp + 15);
        assertEq(bopIt.getBopCooldownRemaining(freshPlayer), 15);

        // Wait full cooldown
        vm.warp(block.timestamp + 15);
        assertEq(bopIt.getBopCooldownRemaining(freshPlayer), 0);
    }

    function test_SetRewardManager() public {
        address newManager = address(0x456);

        bopIt.setRewardManager(newManager);
        assertEq(address(bopIt.rewardManager()), newManager);
    }

    function test_SetRewardManager_OnlyOwner() public {
        address newManager = address(0x456);

        vm.prank(player);
        vm.expectRevert();
        bopIt.setRewardManager(newManager);
    }
}
