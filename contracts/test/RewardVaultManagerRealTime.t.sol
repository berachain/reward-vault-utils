// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {RewardVaultManagerRealTime} from "../src/examples/RewardVaultManagerRealTime.sol";
import {RewardVaultToken} from "../src/examples/RewardVaultToken.sol";
import {FBGT} from "../src/examples/FBGT.sol";
import {LiquidBGTMinter} from "../src/examples/LiquidBGTMinter.sol";
import {IRewardVault} from "../src/interfaces/IRewardVault.sol";

contract RewardVaultManagerRealTimeTest is Test {
    RewardVaultManagerRealTime public manager;
    RewardVaultToken public rewardVaultToken;
    FBGT public fbgtToken;
    LiquidBGTMinter public liquidBGTMinter;

    address public owner = address(0x123);
    address public distributor = address(0x456);
    address public recipient = address(0x789);
    address public nonWhitelistedDistributor = address(0xABC);

    uint256 public constant INITIAL_SUPPLY = 1000000 * 10 ** 18; // 1M tokens
    uint256 public constant DISTRIBUTION_AMOUNT = 100 * 10 ** 18; // 100 tokens

    function setUp() public {
        // Deploy tokens and contracts
        vm.prank(owner);
        manager = new RewardVaultManagerRealTime();
        rewardVaultToken = manager.rewardVaultToken();

        // Whitelist distributor
        vm.prank(owner);
        manager.setDistributorWhitelist(distributor, true);
    }

    function test_Constructor() public {
        assertEq(manager.owner(), owner);
        assertEq(address(manager.rewardVaultToken()), address(rewardVaultToken));
        // Note: liquidBGTToken will be address(0) since minter not set
    }

    function test_SetDistributorWhitelist() public {
        address newDistributor = address(0xDEF);

        vm.prank(owner);
        manager.setDistributorWhitelist(newDistributor, true);
        assertTrue(manager.isWhitelistedDistributor(newDistributor));

        vm.prank(owner);
        manager.setDistributorWhitelist(newDistributor, false);
        assertFalse(manager.isWhitelistedDistributor(newDistributor));
    }

    function test_SetDistributorWhitelist_OnlyOwner() public {
        vm.prank(nonWhitelistedDistributor);
        vm.expectRevert();
        manager.setDistributorWhitelist(distributor, false);
    }

    function test_DistributeRealTimeReward_InvalidAmount() public {
        vm.prank(distributor);
        vm.expectRevert(RewardVaultManagerRealTime.InvalidAmount.selector);
        manager.distributeRealTimeReward(recipient, 0);
    }

    function test_DistributorWhitelistUpdated_Event() public {
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit RewardVaultManagerRealTime.DistributorWhitelistUpdated(distributor, false);
        manager.setDistributorWhitelist(distributor, false);
    }

    function test_WhitelistRemoval() public {
        // Remove distributor from whitelist
        vm.prank(owner);
        manager.setDistributorWhitelist(distributor, false);

        // Try to distribute - should fail
        vm.prank(distributor);
        vm.expectRevert(RewardVaultManagerRealTime.NotWhitelistedDistributor.selector);
        manager.distributeRealTimeReward(recipient, DISTRIBUTION_AMOUNT);
    }

    function test_DistributeRealTimeReward_WithLiquidBGTMinter_Success() public {
        // Setup liquid BGT minter and token
        fbgtToken = new FBGT();
        MockLiquidBGTMinter mockMinter = new MockLiquidBGTMinter(address(fbgtToken));
        
        // Register reward vault and set liquid BGT minter
        MockRewardVault mockVault = new MockRewardVault(address(rewardVaultToken));
        vm.prank(owner);
        manager.registerRewardVault(address(mockVault));
        
        vm.prank(owner);
        manager.setLiquidBGTMinter(address(mockMinter), address(fbgtToken));
        
        // Give some FBGT to the manager for testing
        fbgtToken.mint(address(manager), DISTRIBUTION_AMOUNT);
        
        // Distribute reward
        vm.prank(distributor);
        manager.distributeRealTimeReward(recipient, DISTRIBUTION_AMOUNT);
        
        // Check that recipient received the tokens
        assertEq(fbgtToken.balanceOf(recipient), DISTRIBUTION_AMOUNT);
    }

    function test_DistributeRealTimeReward_WithLiquidBGTMinter_InsufficientBalance() public {
        // Setup liquid BGT minter and token
        fbgtToken = new FBGT();
        MockLiquidBGTMinter mockMinter = new MockLiquidBGTMinter(address(fbgtToken));
        
        // Register reward vault and set liquid BGT minter
        MockRewardVault mockVault = new MockRewardVault(address(rewardVaultToken));
        vm.prank(owner);
        manager.registerRewardVault(address(mockVault));
        
        vm.prank(owner);
        manager.setLiquidBGTMinter(address(mockMinter), address(fbgtToken));
        
        // Don't give any FBGT to the manager
        
        // Try to distribute more than available
        vm.prank(distributor);
        vm.expectEmit(true, true, true, true);
        emit RewardVaultManagerRealTime.RealTimeRewardDistributionFailed(
            distributor, recipient, DISTRIBUTION_AMOUNT, 0
        );
        manager.distributeRealTimeReward(recipient, DISTRIBUTION_AMOUNT);
        
        // Check that recipient didn't receive any tokens
        assertEq(fbgtToken.balanceOf(recipient), 0);
    }

    function test_DistributeRealTimeReward_WithoutLiquidBGTMinter_Success() public {
        // Register reward vault but don't set liquid BGT minter
        MockRewardVault mockVault = new MockRewardVault(address(rewardVaultToken));
        vm.prank(owner);
        manager.registerRewardVault(address(mockVault));
        
        // Set up mock vault to return earned amount
        mockVault.setEarnedAmount(DISTRIBUTION_AMOUNT);
        
        // Distribute reward
        vm.prank(distributor);
        manager.distributeRealTimeReward(recipient, DISTRIBUTION_AMOUNT);
        
        // Check that getPartialReward was called
        assertTrue(mockVault.getPartialRewardCalled());
        assertEq(mockVault.lastAccount(), address(manager));
        assertEq(mockVault.lastRecipient(), recipient);
        assertEq(mockVault.lastAmount(), DISTRIBUTION_AMOUNT);
    }

    function test_DistributeRealTimeReward_WithoutLiquidBGTMinter_InsufficientEarned() public {
        // Register reward vault but don't set liquid BGT minter
        MockRewardVault mockVault = new MockRewardVault(address(rewardVaultToken));
        vm.prank(owner);
        manager.registerRewardVault(address(mockVault));
        
        // Set up mock vault to return less earned amount
        mockVault.setEarnedAmount(DISTRIBUTION_AMOUNT / 2);
        
        // Try to distribute more than earned
        vm.prank(distributor);
        vm.expectEmit(true, true, true, true);
        emit RewardVaultManagerRealTime.RealTimeRewardDistributionFailed(
            distributor, recipient, DISTRIBUTION_AMOUNT, DISTRIBUTION_AMOUNT / 2
        );
        manager.distributeRealTimeReward(recipient, DISTRIBUTION_AMOUNT);
        
        // Check that getPartialReward was not called
        assertFalse(mockVault.getPartialRewardCalled());
    }
}

// Mock RewardVault for testing
contract MockRewardVault is IRewardVault {
    address public stakeToken;
    bool public getPartialRewardCalled;
    address public lastAccount;
    address public lastRecipient;
    uint256 public lastAmount;
    uint256 public earnedAmount;

    constructor(address _stakeToken) {
        stakeToken = _stakeToken;
    }

    function setEarnedAmount(uint256 _amount) external {
        earnedAmount = _amount;
    }

    function earned(address) external view override returns (uint256) {
        return earnedAmount;
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

// Mock LiquidBGTMinter for testing
contract MockLiquidBGTMinter {
    address public fbgt;
    
    constructor(address _fbgt) {
        fbgt = _fbgt;
    }
    
    function mint(address user, address rewardVault, address recipient) external returns (uint256) {
        // Mock implementation - just return 0 for testing
        return 0;
    }
}
