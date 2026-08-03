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

    uint256 public numberOfCampaigns; // Total number of campaigns created and id
    // state variable to store all campaigns
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public pledgeAmount; // mapping of campaignId to donor address to pledge amount

    event CampaignCreated(
        uint256 indexed campaignId,
        address indexed owner,
        string title,
        string description,
        uint256 target,
        uint256 deadline
    );
    event CancelCampaign(uint256 indexed campaignId);
    event Pledge(uint256 indexed campaignId, address indexed donor, uint256 amount);
    event Unpledge(uint256 indexed campaignId, address indexed donor, uint256 amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function createCampaign(string memory _title, string memory _description, uint256 _target, uint256 _deadline)
        external
    {
        require(_deadline > block.timestamp, "Deadline should be in the future");
        campaigns[numberOfCampaigns] = Campaign(msg.sender, _title, _description, _target, _deadline, 0, false);
        numberOfCampaigns++;
        emit CampaignCreated(numberOfCampaigns - 1, msg.sender, _title, _description, _target, _deadline);
    }

    function cancelCampaign(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(msg.sender == campaign.owner, "Only owner can cancel the campaign");
        require(block.timestamp < campaign.deadline, "Cannot cancel after deadline");
        require(campaign.amountCollected == 0, "Cannot cancel a campaign with pledges");
        delete campaigns[_campaignId];
        emit CancelCampaign(_campaignId);
    }

    function pledge(uint256 _campaignId, uint256 _amount) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.deadline, "Cannot pledge after deadline");
        require(_amount > 0, "Pledge amount must be greater than zero");
        campaign.amountCollected += _amount;
        pledgeAmount[_campaignId][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);
        emit Pledge(_campaignId, msg.sender, _amount);
    }

    function unpledge(uint256 _campaignId, uint256 _amount) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.deadline, "Cannot unpledge after deadline");
        require(pledgeAmount[_campaignId][msg.sender] >= _amount, "Not enough pledged amount to unpledge");
        campaign.amountCollected -= _amount;
        pledgeAmount[_campaignId][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        emit Unpledge(_campaignId, msg.sender, _amount);
    }
}
