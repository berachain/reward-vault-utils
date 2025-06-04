// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Owned} from "@solmate/auth/Owned.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {RewardVaultToken} from "../examples/RewardVaultToken.sol";
import {IRewardVault} from "../interfaces/IRewardVault.sol";
import {ILiquidBGTMinter} from "../interfaces/ILiquidBGTMinter.sol";

/// @title RewardVaultManager
/// @notice This contract manages reward vaults by creating and owning a reward vault token
/// @dev The contract can register a reward vault that uses the reward vault token for staking
contract RewardVaultManager is Owned {
    using SafeTransferLib for address;

    /// @notice The reward vault token used for staking
    /// @dev This token is created and owned by this contract
    RewardVaultToken public immutable rewardVaultToken;

    /// @notice The RewardVault contract from Berachain that handles staking and rewards
    /// @dev This is initialized to address(0) and can be set once
    IRewardVault public rewardVault;

    /// @notice The liquid BGT minter contract
    /// @dev This is optional and can be set to address(0) to disable liquid BGT minting
    ILiquidBGTMinter public liquidBGTMinter;

    /// @notice The liquid BGT token associated with the minter
    /// @dev This is set when setting the minter
    address public liquidBGTToken;

    /// @notice Maps token addresses to their total minted amount
    mapping(address => uint256) public tokensMinted;

    /// @notice Maps token addresses to their total allocated amount
    mapping(address => uint256) public tokensAllocated;

    /// @notice Maps token addresses to their total claimed amount
    mapping(address => uint256) public tokensClaimed;

    /// @notice Emitted when a reward vault is registered
    /// @param rewardVault The address of the registered reward vault
    event RewardVaultRegistered(address indexed rewardVault);

    /// @notice Emitted when a liquid BGT minter is set
    /// @param minter The address of the liquid BGT minter
    /// @param token The address of the liquid BGT token
    event LiquidBGTMinterSet(address indexed minter, address indexed token);

    /// @notice Emitted when tokens are minted
    /// @param token The address of the token that was minted
    /// @param amount The amount of tokens minted
    event TokensMinted(address indexed token, uint256 amount);

    /// @notice Custom errors for better gas efficiency and error handling
    error RewardVaultAlreadySet();
    error InvalidRewardVault();
    error NotRewardVaultOwner();
    error InvalidLiquidBGTToken();
    error InsufficientTokens();

    /// @notice Creates a new RewardVaultManager
    /// @dev Creates a new RewardVaultToken with name "Reward Vault Token" and symbol "RVT"
    constructor() Owned(msg.sender) {
        rewardVaultToken = new RewardVaultToken("Reward Vault Token", "RVT", 18);
    }

    /// @notice Registers a reward vault to be used with this manager
    /// @param _rewardVault The address of the reward vault to register
    /// @dev The reward vault must use the reward vault token as its staking token
    /// @dev Can only be called once
    function registerRewardVault(address _rewardVault) external onlyOwner {
        if (address(rewardVault) != address(0)) revert RewardVaultAlreadySet();
        if (_rewardVault == address(0)) revert InvalidRewardVault();

        IRewardVault vault = IRewardVault(_rewardVault);
        if (vault.stakeToken() != address(rewardVaultToken)) revert InvalidRewardVault();

        rewardVault = vault;
        emit RewardVaultRegistered(_rewardVault);
    }

    /// @notice Sets the liquid BGT minter contract and its associated token
    /// @param _minter The address of the liquid BGT minter contract
    /// @param _token The address of the liquid BGT token
    /// @dev Can only be called by the owner
    /// @dev If a reward vault is set, updates its operator to the new minter
    function setLiquidBGTMinter(address _minter, address _token) external onlyOwner {
        if (address(rewardVault) == address(0)) revert InvalidRewardVault();
        if (_token == address(0)) revert InvalidLiquidBGTToken();

        liquidBGTMinter = ILiquidBGTMinter(_minter);
        liquidBGTToken = _token;
        rewardVault.setOperator(_minter);

        emit LiquidBGTMinterSet(_minter, _token);
    }

    /// @notice Mints liquid BGT tokens for BGT rewards
    /// @return The amount of liquid BGT minted
    /// @dev Can only be called if a liquid BGT minter is set
    function mintLiquidBGT() external returns (uint256) {
        if (address(liquidBGTMinter) == address(0)) {
            return 0;
        }
        uint256 amount = liquidBGTMinter.mint(address(this), address(rewardVault), address(this));
        tokensMinted[liquidBGTToken] += amount;
        emit TokensMinted(liquidBGTToken, amount);
        return amount;
    }
}
