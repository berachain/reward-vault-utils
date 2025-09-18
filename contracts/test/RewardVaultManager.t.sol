// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {RewardVaultManager} from "../src/core/RewardVaultManager.sol";
import {RewardVaultToken} from "../src/examples/RewardVaultToken.sol";
import {IRewardVault} from "../src/interfaces/IRewardVault.sol";

// Mock RewardVault for testing
contract MockRewardVault is IRewardVault {
    address public stakeToken;
    bool public getPartialRewardCalled;
    address public lastAccount;
    address public lastRecipient;
    uint256 public lastAmount;

    constructor(address _stakeToken) {
        stakeToken = _stakeToken;
    }

    function getPartialReward(address account, address recipient, uint256 amount) external override {
        getPartialRewardCalled = true;
        lastAccount = account;
        lastRecipient = recipient;
        lastAmount = amount;
    }

    // Mock implementations for other required functions
    function distributor() external pure override returns (address) { return address(0); }
    function operator(address) external pure override returns (address) { return address(0); }
    function getWhitelistedTokensCount() external pure override returns (uint256) { return 0; }
    function getWhitelistedTokens() external pure override returns (address[] memory) { return new address[](0); }
    function getTotalDelegateStaked(address) external pure override returns (uint256) { return 0; }
    function getDelegateStake(address, address) external pure override returns (uint256) { return 0; }
    function earned(address) external pure override returns (uint256) { return 0; }
    function initialize(address, address, address, address) external pure override {}
    function setDistributor(address) external pure override {}
    function notifyRewardAmount(bytes calldata, uint256) external pure override {}
    function recoverERC20(address, uint256) external pure override {}
    function setRewardsDuration(uint256) external pure override {}
    function whitelistIncentiveToken(address, uint256, address) external pure override {}
    function removeIncentiveToken(address) external pure override {}
    function setMaxIncentiveTokensCount(uint8) external pure override {}
    function pause() external pure override {}
    function unpause() external pure override {}
    function exit(address) external pure override {}
    function getReward(address, address) external pure override returns (uint256) { return 0; }
    function stake(uint256) external pure override {}
    function delegateStake(address, uint256) external pure override {}
    function withdraw(uint256) external pure override {}
    function delegateWithdraw(address, uint256) external pure override {}
    function setOperator(address) external pure override {}
    function updateIncentiveManager(address, address) external pure override {}
    function addIncentive(address, uint256, uint256) external pure override {}
    function accountIncentives(address, uint256) external pure override {}
}

contract RewardVaultManagerTest is Test {
    RewardVaultManager public manager;
    RewardVaultToken public token;
    MockRewardVault public mockRewardVault;

    function setUp() public {
        manager = new RewardVaultManager();
        token = manager.rewardVaultToken();
        mockRewardVault = new MockRewardVault(address(token));
    }

    function test_Initialize() public {
        assertEq(address(manager.rewardVault()), address(0));
        assertEq(address(manager.liquidBGTMinter()), address(0));
        assertEq(manager.liquidBGTToken(), address(0));
    }

    function test_ClaimPartialBGTForTarget_Success() public {
        // Register the mock reward vault
        manager.registerRewardVault(address(mockRewardVault));
        
        address testAccount = address(0x123);
        address testRecipient = address(0x456);
        uint256 testAmount = 1000 ether;
        
        // Call the function
        manager.claimPartialBGTForTarget(testAccount, testRecipient, testAmount);
        
        // Verify the mock was called correctly
        assertTrue(mockRewardVault.getPartialRewardCalled());
        assertEq(mockRewardVault.lastAccount(), testAccount);
        assertEq(mockRewardVault.lastRecipient(), testRecipient);
        assertEq(mockRewardVault.lastAmount(), testAmount);
    }

    function test_ClaimPartialBGTForTarget_OnlyOwner() public {
        // Register the mock reward vault
        manager.registerRewardVault(address(mockRewardVault));
        
        // Try to call from non-owner
        vm.prank(address(0x999));
        vm.expectRevert();
        manager.claimPartialBGTForTarget(address(0x123), address(0x456), 1000 ether);
    }

    function test_ClaimPartialBGTForTarget_NoRewardVault() public {
        // Try to call without registering a reward vault
        vm.expectRevert(RewardVaultManager.InvalidRewardVault.selector);
        manager.claimPartialBGTForTarget(address(0x123), address(0x456), 1000 ether);
    }
}
