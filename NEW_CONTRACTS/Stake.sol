// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract Stake {
    ERC20 public token;
    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor() {
        token = ERC20(0xAD531A13b61E6Caf50caCdcEebEbFA8E6F5Cbc4D);
    }

    function deposit(uint256 _amount) public {
        require(_amount > 0, "deposit: amount cannot be 0");
        token.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    function withdraw() public {
        // TODO: withdraw only specified amount (now it withdraws everything)
        uint256 balance = stakingBalance[msg.sender];
        require(balance > 0, "withdraw: staking balance cannot be 0");
        token.transfer((msg.sender, balance));
        stakingBalance[msg.sender] = 0;
        isStaking[msg.sender] = false;
    }

    function harvest() public {

    }


    // Issue tokens to all stakers
    // Only owner can call this function
    function issueTokens() public ownerOnly {
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint256 balance = stakingBalance[recipient];
            if (balance > 0) {
                token.transfer(recipient, balance);
            }
        }
    }
}
