// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {Button} from "../src/Button.sol";

contract ButtonTest is Test {
    Button public button;
    address public user1;
    address public user2;

    function setUp() public {
        button = new Button();
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
    }

    function testInitialLastPressTime() public {
        vm.warp(3600);
        emit log_named_uint("block.timestamp", block.timestamp);
        emit log_named_uint("lastPressTime[user1]", button.lastPressTime(user1));
        assertEq(button.lastPressTime(user1), 0);
    }

    function testPressButton() public {
        vm.warp(3600);
        emit log_named_uint("block.timestamp", block.timestamp);
        emit log_named_uint("lastPressTime[user1]", button.lastPressTime(user1));
        vm.startPrank(user1);
        button.pressButton();
        assertEq(button.lastPressTime(user1), block.timestamp);
        vm.stopPrank();
    }

    function testCannotPressWithinOneHour() public {
        vm.warp(3600);
        emit log_named_uint("block.timestamp", block.timestamp);
        emit log_named_uint("lastPressTime[user1]", button.lastPressTime(user1));
        vm.startPrank(user1);
        button.pressButton();
        vm.expectRevert("Can only press button once per hour");
        button.pressButton();
        vm.stopPrank();
    }

    function testCanPressAfterOneHour() public {
        vm.warp(3600);
        emit log_named_uint("block.timestamp", block.timestamp);
        emit log_named_uint("lastPressTime[user1]", button.lastPressTime(user1));
        vm.startPrank(user1);
        button.pressButton();
        uint256 firstPressTime = block.timestamp;
        
        // Fast forward 1 hour + 1 second
        vm.warp(firstPressTime + 1 hours + 1 seconds);
        
        button.pressButton();
        assertEq(button.lastPressTime(user1), block.timestamp);
        vm.stopPrank();
    }

    function testDifferentUsersCanPress() public {
        vm.warp(3600);
        emit log_named_uint("block.timestamp", block.timestamp);
        emit log_named_uint("lastPressTime[user1]", button.lastPressTime(user1));
        vm.startPrank(user1);
        button.pressButton();
        vm.stopPrank();

        vm.startPrank(user2);
        button.pressButton();
        assertEq(button.lastPressTime(user2), block.timestamp);
        vm.stopPrank();
    }
} 