// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IRewardVaultFactory {
    function createRewardVault(address stakingToken) external returns (address);
} 