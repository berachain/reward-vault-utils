// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {CompetitionManager} from "../src/CompetitionManager.sol";
import {CompetitionToken} from "../src/CompetitionToken.sol";

contract MockRewardVault {
    address public token;
    constructor(address _token) { token = _token; }
    function stakeToken() external view returns (address) { return token; }
}

contract CompetitionManagerTest is Test {
    CompetitionManager public manager;
    address public owner = address(0xABCD);
    address public notOwner = address(0x1234);
    CompetitionToken public token;
    MockRewardVault public mockVault;

    function setUp() public {
        vm.prank(owner);
        manager = new CompetitionManager();
        token = manager.competitionToken();
        mockVault = new MockRewardVault(address(token));
    }

    function testOwnerIsSet() public {
        assertEq(manager.owner(), owner);
    }

    function testCompetitionTokenIsDeployed() public {
        CompetitionToken token_ = manager.competitionToken();
        assertEq(token_.name(), "Competition Token");
        assertEq(token_.symbol(), "CT");
        assertEq(token_.decimals(), 18);
    }

    function testRegisterRewardVaultOnlyOwner() public {
        vm.prank(notOwner);
        vm.expectRevert();
        manager.registerRewardVault(address(mockVault));
    }

    function testRevertWhenRegisterRewardVaultTwice() public {
        vm.prank(owner);
        manager.registerRewardVault(address(mockVault));
        vm.prank(owner);
        vm.expectRevert(abi.encodeWithSelector(CompetitionManager.RewardVaultAlreadySet.selector));
        manager.registerRewardVault(address(mockVault));
    }
} 