// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {Button} from "../src/examples/Button.sol";

contract ButtonTest is Test {
    Button public button;
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    uint256 public constant INITIAL_TIMESTAMP = 1000;

    function setUp() public {
        vm.warp(INITIAL_TIMESTAMP);
        button = new Button();
        vm.label(address(button), "Button");
        vm.warp(block.timestamp + 1 hours);
    }

    function test_InitialState() public view {
        assertEq(button.COOLDOWN_PERIOD(), 1 hours);
        assertEq(button.lastPressTime(alice), 0);
        assertEq(button.lastPressTime(bob), 0);
    }

    function test_PressButton() public {
        vm.startPrank(alice);
        button.pressButton();
        assertEq(button.lastPressTime(alice), block.timestamp);
        vm.stopPrank();
    }

    function test_PressButtonCooldown() public {
        vm.startPrank(alice);
        button.pressButton();
        vm.expectRevert(Button.ButtonCooldownActive.selector);
        button.pressButton();
        vm.stopPrank();
    }

    function test_PressButtonAfterCooldown() public {
        uint256 startTime = block.timestamp;
        vm.startPrank(alice);
        button.pressButton();
        vm.warp(startTime + 1 hours + 1);
        button.pressButton();
        vm.stopPrank();

        assertEq(button.lastPressTime(alice), startTime + 1 hours + 1);
    }

    function test_MultipleUsers() public {
        vm.startPrank(alice);
        button.pressButton();
        vm.stopPrank();

        vm.startPrank(bob);
        button.pressButton();
        vm.stopPrank();

        assertEq(button.lastPressTime(bob), block.timestamp);
    }
}
