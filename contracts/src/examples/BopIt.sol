// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Owned} from "@solmate/auth/Owned.sol";

interface IRewardVaultManagerRealTime {
    function distributeRealTimeReward(address recipient, uint256 amount) external;
}

contract BopIt is Owned {
    IRewardVaultManagerRealTime public rewardManager;

    // Cooldown tracking for each action
    mapping(address => uint256) public lastBopTime;
    mapping(address => uint256) public lastTwistTime;
    mapping(address => uint256) public lastPullTime;
    mapping(address => uint256) public lastSpinTime;
    mapping(address => uint256) public lastFlickTime;

    // Cooldown periods (in seconds)
    uint256 public constant BOP_COOLDOWN = 30; // 30 seconds
    uint256 public constant TWIST_COOLDOWN = 60; // 1 minute
    uint256 public constant PULL_COOLDOWN = 90; // 1.5 minutes
    uint256 public constant SPIN_COOLDOWN = 120; // 2 minutes
    uint256 public constant FLICK_COOLDOWN = 180; // 3 minutes

    // Reward amounts (in wei, sub 0.1 BERA)
    uint256 public constant BOP_REWARD = 0.01 ether; // 0.01 BERA
    uint256 public constant TWIST_REWARD = 0.02 ether; // 0.02 BERA
    uint256 public constant PULL_REWARD = 0.03 ether; // 0.03 BERA
    uint256 public constant SPIN_REWARD = 0.04 ether; // 0.04 BERA
    uint256 public constant FLICK_REWARD = 0.05 ether; // 0.05 BERA

    event ActionPerformed(address indexed player, string action, uint256 reward, uint256 timestamp);
    event CooldownNotMet(address indexed player, string action, uint256 remainingTime);

    constructor(address _rewardManager) Owned(msg.sender) {
        rewardManager = IRewardVaultManagerRealTime(_rewardManager);
    }

    modifier checkCooldown(uint256 lastActionTime, uint256 cooldown) {
        uint256 timeSinceLastAction = block.timestamp - lastActionTime;
        require(timeSinceLastAction >= cooldown, "Cooldown not met");
        _;
    }

    function setRewardManager(address _rewardManager) external onlyOwner {
        rewardManager = IRewardVaultManagerRealTime(_rewardManager);
    }

    function bop() external {
        require(
            lastBopTime[msg.sender] == 0 || block.timestamp - lastBopTime[msg.sender] >= BOP_COOLDOWN,
            "Bop cooldown not met"
        );

        lastBopTime[msg.sender] = block.timestamp;

        // Distribute reward
        rewardManager.distributeRealTimeReward(msg.sender, BOP_REWARD);

        emit ActionPerformed(msg.sender, "BOP", BOP_REWARD, block.timestamp);
    }

    function twist() external {
        require(
            lastTwistTime[msg.sender] == 0 || block.timestamp - lastTwistTime[msg.sender] >= TWIST_COOLDOWN,
            "Twist cooldown not met"
        );

        lastTwistTime[msg.sender] = block.timestamp;

        // Distribute reward
        rewardManager.distributeRealTimeReward(msg.sender, TWIST_REWARD);

        emit ActionPerformed(msg.sender, "TWIST", TWIST_REWARD, block.timestamp);
    }

    function pull() external {
        require(
            lastPullTime[msg.sender] == 0 || block.timestamp - lastPullTime[msg.sender] >= PULL_COOLDOWN,
            "Pull cooldown not met"
        );

        lastPullTime[msg.sender] = block.timestamp;

        // Distribute reward
        rewardManager.distributeRealTimeReward(msg.sender, PULL_REWARD);

        emit ActionPerformed(msg.sender, "PULL", PULL_REWARD, block.timestamp);
    }

    function spin() external {
        require(
            lastSpinTime[msg.sender] == 0 || block.timestamp - lastSpinTime[msg.sender] >= SPIN_COOLDOWN,
            "Spin cooldown not met"
        );

        lastSpinTime[msg.sender] = block.timestamp;

        // Distribute reward
        rewardManager.distributeRealTimeReward(msg.sender, SPIN_REWARD);

        emit ActionPerformed(msg.sender, "SPIN", SPIN_REWARD, block.timestamp);
    }

    function flick() external {
        require(
            lastFlickTime[msg.sender] == 0 || block.timestamp - lastFlickTime[msg.sender] >= FLICK_COOLDOWN,
            "Flick cooldown not met"
        );

        lastFlickTime[msg.sender] = block.timestamp;

        // Distribute reward
        rewardManager.distributeRealTimeReward(msg.sender, FLICK_REWARD);

        emit ActionPerformed(msg.sender, "FLICK", FLICK_REWARD, block.timestamp);
    }

    // View functions to check cooldowns
    function getBopCooldownRemaining(address player) external view returns (uint256) {
        if (lastBopTime[player] == 0) return 0;
        uint256 timeSinceLastAction = block.timestamp - lastBopTime[player];
        return timeSinceLastAction >= BOP_COOLDOWN ? 0 : BOP_COOLDOWN - timeSinceLastAction;
    }

    function getTwistCooldownRemaining(address player) external view returns (uint256) {
        if (lastTwistTime[player] == 0) return 0;
        uint256 timeSinceLastAction = block.timestamp - lastTwistTime[player];
        return timeSinceLastAction >= TWIST_COOLDOWN ? 0 : TWIST_COOLDOWN - timeSinceLastAction;
    }

    function getPullCooldownRemaining(address player) external view returns (uint256) {
        if (lastPullTime[player] == 0) return 0;
        uint256 timeSinceLastAction = block.timestamp - lastPullTime[player];
        return timeSinceLastAction >= PULL_COOLDOWN ? 0 : PULL_COOLDOWN - timeSinceLastAction;
    }

    function getSpinCooldownRemaining(address player) external view returns (uint256) {
        if (lastSpinTime[player] == 0) return 0;
        uint256 timeSinceLastAction = block.timestamp - lastSpinTime[player];
        return timeSinceLastAction >= SPIN_COOLDOWN ? 0 : SPIN_COOLDOWN - timeSinceLastAction;
    }

    function getFlickCooldownRemaining(address player) external view returns (uint256) {
        if (lastFlickTime[player] == 0) return 0;
        uint256 timeSinceLastAction = block.timestamp - lastFlickTime[player];
        return timeSinceLastAction >= FLICK_COOLDOWN ? 0 : FLICK_COOLDOWN - timeSinceLastAction;
    }
}
