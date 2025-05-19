// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ButtonPressCompetition
/// @notice A simple competition where users can press a button and earn rewards based on their participation
/// @dev The competition periods are managed off-chain, this contract only tracks button presses
contract ButtonPressCompetition {
    /// @notice Emitted when a user presses the button
    /// @param user The address of the user who pressed the button
    /// @param competitionId The ID of the current competition period
    /// @param timestamp The block timestamp when the button was pressed
    event ButtonPressed(address indexed user, uint256 indexed competitionId, uint256 timestamp);

    /// @notice Tracks the number of button presses per user per competition
    mapping(uint256 => mapping(address => uint256)) public pressCounts;

    /// @notice Tracks the total number of button presses per competition
    mapping(uint256 => uint256) public totalPresses;

    /// @notice The current competition ID
    /// @dev This is incremented by the off-chain service when a new competition period starts
    uint256 public currentCompetitionId;

    /// @notice Allows a user to press the button in the current competition
    /// @dev Emits a ButtonPressed event with the user's address, competition ID, and timestamp
    function pressButton() external {
        uint256 compId = currentCompetitionId;
        pressCounts[compId][msg.sender]++;
        totalPresses[compId]++;
        emit ButtonPressed(msg.sender, compId, block.timestamp);
    }

    /// @notice Advances to the next competition period
    /// @dev This should be called by the off-chain service when a competition period ends
    function advanceCompetition() external {
        currentCompetitionId++;
    }
} 