// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// src/Button.sol

contract Button {
    // Mapping to track the last press time for each user
    mapping(address => uint256) public lastPressTime;
    
    // Event emitted when button is pressed
    event ButtonPressed(address indexed user, uint256 timestamp);
    
    // Function to press the button
    function pressButton() external {
        // Get the current timestamp
        uint256 currentTime = block.timestamp;
        
        // Check if user has pressed the button in the last hour
        require(
            currentTime >= lastPressTime[msg.sender] + 1 hours,
            "Can only press button once per hour"
        );
        
        // Update the last press time for the user
        lastPressTime[msg.sender] = currentTime;
        
        // Emit the event
        emit ButtonPressed(msg.sender, currentTime);
    }
}
