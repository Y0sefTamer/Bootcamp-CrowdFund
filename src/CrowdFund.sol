// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract CrowdFund {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target; // the goal amount
        uint256 deadline; // timestamp of the deadline
        uint256 amountCollected; //pledge amount
        bool claimed; // whether the campaign has been claimed
        mapping(address => uint256) donations; // mapping of donors to their donation amounts
    }
}
