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
}
