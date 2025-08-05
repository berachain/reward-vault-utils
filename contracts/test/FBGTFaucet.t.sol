// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FBGTFaucet} from "../src/utilities/FBGTFaucet.sol";
import {FBGT} from "../src/examples/FBGT.sol";

contract FBGTFaucetTest is Test {
    FBGTFaucet public faucet;
    FBGT public fbgtToken;

    address public owner = address(0x123);
    address public user1 = address(0x456);
    address public user2 = address(0x789);
    address public user3 = address(0xABC);

    uint256 public constant INITIAL_SUPPLY = 1000000 * 10 ** 18; // 1M tokens
    uint256 public constant DISTRIBUTION_AMOUNT = 100 * 10 ** 18; // 100 tokens

    function setUp() public {
        // Deploy FBGT token
        fbgtToken = new FBGT();

        // Deploy faucet
        vm.prank(owner);
        faucet = new FBGTFaucet(address(fbgtToken));

        // Mint some tokens to the faucet
        fbgtToken.mint(address(faucet), INITIAL_SUPPLY / 2);
    }

    function test_Constructor() public {
        assertEq(faucet.owner(), owner);
        assertEq(faucet.getFBGTAddress(), address(fbgtToken));
        assertEq(faucet.getFaucetBalance(), INITIAL_SUPPLY / 2);
    }

    function test_DistributeTokens() public {
        uint256 initialBalance = fbgtToken.balanceOf(user1);

        vm.prank(owner);
        faucet.distributeTokens(user1, DISTRIBUTION_AMOUNT);

        assertEq(fbgtToken.balanceOf(user1), initialBalance + DISTRIBUTION_AMOUNT);
        assertEq(fbgtToken.balanceOf(address(faucet)), (INITIAL_SUPPLY / 2) - DISTRIBUTION_AMOUNT);
    }

    function test_DistributeTokensBatch() public {
        address[] memory recipients = new address[](2);
        uint256[] memory amounts = new uint256[](2);

        recipients[0] = user1;
        recipients[1] = user2;
        amounts[0] = DISTRIBUTION_AMOUNT;
        amounts[1] = DISTRIBUTION_AMOUNT * 2;

        uint256 totalAmount = DISTRIBUTION_AMOUNT + (DISTRIBUTION_AMOUNT * 2);
        uint256 initialBalance1 = fbgtToken.balanceOf(user1);
        uint256 initialBalance2 = fbgtToken.balanceOf(user2);

        vm.prank(owner);
        faucet.distributeTokensBatch(recipients, amounts);

        assertEq(fbgtToken.balanceOf(user1), initialBalance1 + DISTRIBUTION_AMOUNT);
        assertEq(fbgtToken.balanceOf(user2), initialBalance2 + (DISTRIBUTION_AMOUNT * 2));
        assertEq(fbgtToken.balanceOf(address(faucet)), (INITIAL_SUPPLY / 2) - totalAmount);
    }

    function test_WithdrawTokens() public {
        uint256 withdrawAmount = 1000 * 10 ** 18;
        uint256 initialOwnerBalance = fbgtToken.balanceOf(owner);

        vm.prank(owner);
        faucet.withdrawTokens(withdrawAmount);

        assertEq(fbgtToken.balanceOf(owner), initialOwnerBalance + withdrawAmount);
        assertEq(fbgtToken.balanceOf(address(faucet)), (INITIAL_SUPPLY / 2) - withdrawAmount);
    }

    function test_RevertWhenNonOwnerDistributes() public {
        vm.prank(user1);
        vm.expectRevert();
        faucet.distributeTokens(user2, DISTRIBUTION_AMOUNT);
    }

    function test_RevertWhenNonOwnerDistributesBatch() public {
        address[] memory recipients = new address[](1);
        uint256[] memory amounts = new uint256[](1);
        recipients[0] = user1;
        amounts[0] = DISTRIBUTION_AMOUNT;

        vm.prank(user1);
        vm.expectRevert();
        faucet.distributeTokensBatch(recipients, amounts);
    }

    function test_RevertWhenNonOwnerWithdraws() public {
        vm.prank(user1);
        vm.expectRevert();
        faucet.withdrawTokens(DISTRIBUTION_AMOUNT);
    }

    function test_RevertWhenDistributingToZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert("Invalid recipient");
        faucet.distributeTokens(address(0), DISTRIBUTION_AMOUNT);
    }

    function test_RevertWhenDistributingZeroAmount() public {
        vm.prank(owner);
        vm.expectRevert("Amount must be greater than 0");
        faucet.distributeTokens(user1, 0);
    }

    function test_RevertWhenInsufficientBalance() public {
        uint256 largeAmount = INITIAL_SUPPLY + 1;

        vm.prank(owner);
        vm.expectRevert("Insufficient balance");
        faucet.distributeTokens(user1, largeAmount);
    }

    function test_RevertWhenBatchArraysLengthMismatch() public {
        address[] memory recipients = new address[](2);
        uint256[] memory amounts = new uint256[](1);
        recipients[0] = user1;
        recipients[1] = user2;
        amounts[0] = DISTRIBUTION_AMOUNT;

        vm.prank(owner);
        vm.expectRevert("Arrays length mismatch");
        faucet.distributeTokensBatch(recipients, amounts);
    }

    function test_RevertWhenBatchEmptyArrays() public {
        address[] memory recipients = new address[](0);
        uint256[] memory amounts = new uint256[](0);

        vm.prank(owner);
        vm.expectRevert("Empty arrays");
        faucet.distributeTokensBatch(recipients, amounts);
    }

    function test_RevertWhenBatchZeroAddress() public {
        address[] memory recipients = new address[](1);
        uint256[] memory amounts = new uint256[](1);
        recipients[0] = address(0);
        amounts[0] = DISTRIBUTION_AMOUNT;

        vm.prank(owner);
        vm.expectRevert("Invalid recipient");
        faucet.distributeTokensBatch(recipients, amounts);
    }

    function test_RevertWhenBatchZeroAmount() public {
        address[] memory recipients = new address[](1);
        uint256[] memory amounts = new uint256[](1);
        recipients[0] = user1;
        amounts[0] = 0;

        vm.prank(owner);
        vm.expectRevert("Amount must be greater than 0");
        faucet.distributeTokensBatch(recipients, amounts);
    }

    function test_RevertWhenBatchInsufficientBalance() public {
        address[] memory recipients = new address[](1);
        uint256[] memory amounts = new uint256[](1);
        recipients[0] = user1;
        amounts[0] = INITIAL_SUPPLY + 1;

        vm.prank(owner);
        vm.expectRevert("Insufficient balance");
        faucet.distributeTokensBatch(recipients, amounts);
    }

    function test_RevertWhenWithdrawingZeroAmount() public {
        vm.prank(owner);
        vm.expectRevert("Amount must be greater than 0");
        faucet.withdrawTokens(0);
    }

    function test_RevertWhenWithdrawingInsufficientBalance() public {
        uint256 largeAmount = INITIAL_SUPPLY + 1;

        vm.prank(owner);
        vm.expectRevert("Insufficient balance");
        faucet.withdrawTokens(largeAmount);
    }

    function test_GetFaucetBalance() public {
        assertEq(faucet.getFaucetBalance(), INITIAL_SUPPLY / 2);

        // After distribution
        vm.prank(owner);
        faucet.distributeTokens(user1, DISTRIBUTION_AMOUNT);

        assertEq(faucet.getFaucetBalance(), (INITIAL_SUPPLY / 2) - DISTRIBUTION_AMOUNT);
    }

    function test_GetFBGTAddress() public {
        assertEq(faucet.getFBGTAddress(), address(fbgtToken));
    }

    function test_Events() public {
        // Test TokensDistributed event
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit FBGTFaucet.TokensDistributed(user1, DISTRIBUTION_AMOUNT);
        faucet.distributeTokens(user1, DISTRIBUTION_AMOUNT);

        // Test TokensWithdrawn event
        uint256 withdrawAmount = 1000 * 10 ** 18;
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit FBGTFaucet.TokensWithdrawn(owner, withdrawAmount);
        faucet.withdrawTokens(withdrawAmount);
    }

    function test_ComplexBatchDistribution() public {
        address[] memory recipients = new address[](3);
        uint256[] memory amounts = new uint256[](3);

        recipients[0] = user1;
        recipients[1] = user2;
        recipients[2] = user3;
        amounts[0] = DISTRIBUTION_AMOUNT;
        amounts[1] = DISTRIBUTION_AMOUNT * 2;
        amounts[2] = DISTRIBUTION_AMOUNT * 3;

        uint256 totalAmount = DISTRIBUTION_AMOUNT + (DISTRIBUTION_AMOUNT * 2) + (DISTRIBUTION_AMOUNT * 3);

        vm.prank(owner);
        faucet.distributeTokensBatch(recipients, amounts);

        assertEq(fbgtToken.balanceOf(user1), DISTRIBUTION_AMOUNT);
        assertEq(fbgtToken.balanceOf(user2), DISTRIBUTION_AMOUNT * 2);
        assertEq(fbgtToken.balanceOf(user3), DISTRIBUTION_AMOUNT * 3);
        assertEq(fbgtToken.balanceOf(address(faucet)), (INITIAL_SUPPLY / 2) - totalAmount);
    }
}
