// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {RewardVaultLootBox} from "../src/examples/RewardVaultLootBox.sol";
import {RewardVaultToken} from "../src/examples/RewardVaultToken.sol";
import {FBGT} from "../src/examples/FBGT.sol";
import {LootBox} from "../src/examples/LootBox.sol";
import {IRewardVault} from "../src/interfaces/IRewardVault.sol";

contract RewardVaultLootBoxTest is Test {
    RewardVaultLootBox public lootBoxVault;
    RewardVaultToken public rewardVaultToken;
    FBGT public fbgtToken;
    LootBox public lootBoxContract;
    MockRewardVault public mockRewardVault;
    MockLiquidBGTMinter public mockMinter;

    address public owner = address(0x123);
    address public creator = address(0x456);
    address public opener = address(0x789);

    function setUp() public {
        // Deploy contracts with valid probability arrays
        uint256[] memory probabilities = new uint256[](5);
        probabilities[0] = 5000; // COMMON: 50%
        probabilities[1] = 2500; // UNCOMMON: 25%
        probabilities[2] = 1500; // RARE: 15%
        probabilities[3] = 800;  // EPIC: 8%
        probabilities[4] = 200;  // LEGENDARY: 2%
        
        uint256[] memory rewardBips = new uint256[](5);
        rewardBips[0] = 100;  // COMMON: 1%
        rewardBips[1] = 200;  // UNCOMMON: 2%
        rewardBips[2] = 500;  // RARE: 5%
        rewardBips[3] = 1000; // EPIC: 10%
        rewardBips[4] = 2000; // LEGENDARY: 20%
        
        vm.prank(owner);
        lootBoxVault = new RewardVaultLootBox(
            address(0x1), // Mock entropy contract
            address(0x2), // Mock loot box contract
            address(0x3), // Mock entropy provider
            probabilities,
            rewardBips
        );
        
        rewardVaultToken = lootBoxVault.rewardVaultToken();
        fbgtToken = new FBGT();
        lootBoxContract = new LootBox("Test LootBox", "TLB", "https://test.com/");
        mockRewardVault = new MockRewardVault(address(rewardVaultToken));
        mockMinter = new MockLiquidBGTMinter(address(fbgtToken));
        
        // Set up creator approval
        vm.prank(owner);
        lootBoxVault.setCreatorApproval(creator, true);
    }

    function test_SetLiquidBGTToken() public {
        vm.prank(owner);
        lootBoxVault.setLiquidBGTToken(address(fbgtToken));
        
        assertEq(lootBoxVault.liquidBGTToken(), address(fbgtToken));
    }

    function test_SetLiquidBGTToken_OnlyOwner() public {
        vm.prank(creator);
        vm.expectRevert();
        lootBoxVault.setLiquidBGTToken(address(fbgtToken));
    }

    function test_SetLiquidBGTToken_ZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert();
        lootBoxVault.setLiquidBGTToken(address(0));
    }
}

// Mock RewardVault for testing
contract MockRewardVault is IRewardVault {
    address public stakeToken;
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

    function getPartialReward(address, address, uint256) external pure override {}

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
    
    function mint(address, address, address) external pure returns (uint256) {
        return 0;
    }
}
