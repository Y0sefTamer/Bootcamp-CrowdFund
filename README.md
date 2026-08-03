# Bootcamp CrowdFund 💰

A foundational Crowdfunding smart contract project built as part of a Web3 Solidity Bootcamp. This repository demonstrates how to build a decentralized Kickstarter-style application where users can pool funds together to reach a target goal within a specific timeframe.

## 🌟 Features

* **Set Goals & Deadlines:** The contract initializes with a specific funding goal and a time limit (deadline).
* **Pledging System:** Users can send ETH to the contract to support the campaign.
* **Claiming Funds:** If the campaign successfully reaches its goal by the deadline, the creator can withdraw the pooled funds.
* **Trustless Refunds:** If the deadline passes and the goal is *not* met, backers can securely withdraw their pledged ETH. No admin intervention is required.
* **State Tracking:** Keeps accurate records of total funds raised and individual contributor balances.

## 🛠️ Tech Stack

* **Smart Contracts:** Solidity `^0.8.27`
* **Framework:** Foundry

## 🏛️ How It Works

1. **Launch:** The creator deploys the contract, setting a `goal` (in wei) and a `deadline` (timestamp).
2. **Fund:** Backers call the `pledge()` or `fund()` function and send ETH to the contract.
3. **Outcome A (Success):** If the total pledged equals or exceeds the goal, the campaign is successful. The creator can call `claim()` to transfer the funds to their wallet.
4. **Outcome B (Failure):** If the deadline passes and the goal hasn't been met, the campaign fails. Backers can call `refund()` to get their exact deposited amount back.

