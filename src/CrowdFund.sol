// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
interface IERC20 {
    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
}
contract CrowdFund {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target; // the goal amount
        uint256 deadline; // timestamp of the deadline
        uint256 amountCollected; //pledge amount
        bool claimed; // whether the campaign has been claimed
    }
    IERC20 public immutable token; // ERC20 token used for pledging

    uint256 public numberOfCampaigns ; // Total number of campaigns created and id
    // state variable to store all campaigns
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public pledgeAmount; // mapping of campaignId to donor address to pledge amount

    constructor(address _token) {
        token = IERC20(_token);
    }

}
