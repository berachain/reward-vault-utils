// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {RewardVaultManager} from "../src/core/RewardVaultManager.sol";
import {RewardVaultToken} from "../src/examples/RewardVaultToken.sol";
import {IRewardVault} from "../src/interfaces/IRewardVault.sol";

contract RewardVaultManagerTest is Test {
    RewardVaultManager public manager;
    RewardVaultToken public token;
    IRewardVault public rewardVault;

    function setUp() public {
        manager = new RewardVaultManager();
        token = manager.rewardVaultToken();
    }

    function test_Initialize() public {
        assertEq(address(manager.rewardVault()), address(0));
        assertEq(address(manager.liquidBGTMinter()), address(0));
        assertEq(manager.liquidBGTToken(), address(0));
    }
}
