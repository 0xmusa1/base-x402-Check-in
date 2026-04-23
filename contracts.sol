// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BaseX402CheckIn {

    string public name = "Base x402 Check-In";
    string public symbol = "X402";

    uint256 public tokenIdCounter;
    uint256 public constant COOLDOWN = 1 days;

    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256) public balanceOf;

    mapping(address => uint256) public lastCheckIn;
    mapping(address => uint256) public streak;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event CheckedIn(address indexed user, uint256 tokenId, uint256 streak);

    function checkIn() external {
        require(
            block.timestamp >= lastCheckIn[msg.sender] + COOLDOWN,
            "Wait 24 hours"
        );

        if (block.timestamp <= lastCheckIn[msg.sender] + COOLDOWN + 1 hours) {
            streak[msg.sender] += 1;
        } else {
            streak[msg.sender] = 1;
        }

        lastCheckIn[msg.sender] = block.timestamp;

        tokenIdCounter++;
        uint256 newId = tokenIdCounter;

        ownerOf[newId] = msg.sender;
        balanceOf[msg.sender]++;

        emit Transfer(address(0), msg.sender, newId);
        emit CheckedIn(msg.sender, newId, streak[msg.sender]);
    }

    function getStreak(address user) external view returns (uint256) {
        return streak[user];
    }
}
