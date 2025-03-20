// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedStudyTimer {
    struct StudySession {
        uint256 totalTime; // Total study time in seconds
        uint256 earnedTokens;
        uint256 lastStartTime;
        bool isStudying;
    }

    mapping(address => StudySession) public users;
    uint256 public rewardPerMinute = 1; // Tokens rewarded per minute of study

    event StudyStarted(address indexed user, uint256 startTime);
    event StudyStopped(address indexed user, uint256 totalTime, uint256 earnedTokens);

    function startStudy() public {
        StudySession storage session = users[msg.sender];
        require(!session.isStudying, "Study session already in progress");
        
        session.lastStartTime = block.timestamp;
        session.isStudying = true;
        emit StudyStarted(msg.sender, session.lastStartTime);
    }

    function stopStudy() public {
        StudySession storage session = users[msg.sender];
        require(session.isStudying, "No study session in progress");
        
        uint256 studyDuration = block.timestamp - session.lastStartTime;
        uint256 earned = (studyDuration / 60) * rewardPerMinute;
        session.totalTime += studyDuration;
        session.earnedTokens += earned;
        session.isStudying = false;
        
        emit StudyStopped(msg.sender, session.totalTime, session.earnedTokens);
    }

    function getStudyData(address user) public view returns (uint256, uint256) {
        return (users[user].totalTime, users[user].earnedTokens);
    }
}