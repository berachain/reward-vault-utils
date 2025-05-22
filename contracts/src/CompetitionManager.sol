// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Owned} from "@solmate/auth/Owned.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {CompetitionToken} from "./CompetitionToken.sol";
import {IRewardVault} from "@berachain/pol/rewards/RewardVault.sol";

/// @title CompetitionManager
/// @notice This contract manages competitions by creating and owning a competition token
/// @dev The contract can register a reward vault that uses the competition token for staking
contract CompetitionManager is Owned {
    using SafeTransferLib for address;

    /// @notice The competition token used for staking
    /// @dev This token is created and owned by this contract
    CompetitionToken public immutable competitionToken;

    /// @notice The RewardVault contract from Berachain that handles staking and rewards
    /// @dev This is initialized to address(0) and can be set once
    IRewardVault public rewardVault;

    /// @notice Emitted when a reward vault is registered
    /// @param rewardVault The address of the registered reward vault
    event RewardVaultRegistered(address indexed rewardVault);

    /// @notice Custom errors for better gas efficiency and error handling
    error RewardVaultAlreadySet();
    error InvalidRewardVault();
    error NotRewardVaultOwner();

    /// @notice Creates a new CompetitionManager
    /// @dev Creates a new CompetitionToken with name "Competition Token" and symbol "CT"
    constructor() Owned(msg.sender) {
        competitionToken = new CompetitionToken("Competition Token", "CT", 18);
    }

    /// @notice Registers a reward vault to be used with this competition manager
    /// @param _rewardVault The address of the reward vault to register
    /// @dev The reward vault must use the competition token as its staking token
    /// @dev Can only be called once
    function registerRewardVault(address _rewardVault) external onlyOwner {
        if (address(rewardVault) != address(0)) revert RewardVaultAlreadySet();
        if (_rewardVault == address(0)) revert InvalidRewardVault();

        IRewardVault vault = IRewardVault(_rewardVault);
        if (vault.stakingToken() != address(competitionToken)) revert InvalidRewardVault();

        rewardVault = vault;
        emit RewardVaultRegistered(_rewardVault);
    }
} 