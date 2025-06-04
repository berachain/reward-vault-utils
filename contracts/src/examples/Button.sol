// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Button
/// @notice A simple example contract that emits an event when pressed
/// @dev This is used as an example of a simple contract that can be used with the reward vault
contract Button {
    /// @notice Emitted when the button is pressed
    /// @param presser The address of the account that pressed the button
    event ButtonPressed(address indexed presser);

    /// @notice Maps user addresses to their last press time
    mapping(address => uint256) public lastPressTime;

    /// @notice The cooldown period between button presses (1 hour)
    uint256 public constant COOLDOWN_PERIOD = 1 hours;

    /// @notice Custom error for when button is on cooldown
    error ButtonCooldownActive();

    /// @notice Presses the button
    /// @dev Emits a ButtonPressed event with the caller's address
    /// @dev Can only be pressed once per hour per user
    function pressButton() external {
        if (block.timestamp < lastPressTime[msg.sender] + COOLDOWN_PERIOD) {
            revert ButtonCooldownActive();
        }
        lastPressTime[msg.sender] = block.timestamp;
        emit ButtonPressed(msg.sender);
    }
}
