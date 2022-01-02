// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Airdropper is Ownable {
    using SafeMath for uint256;
    uint256 public totalClaimed;
    uint256 public amountOfTokens;
    uint256 public airdropsCount;
    address burnAddress;
    mapping (address => bool) public addressReceived;
    ERC20 public token;

    constructor() {
        totalClaimed = 0;
        amountOfTokens = 1000 * 10**18;
        burnAddress = 0x000000000000000000000000000000000000dEaD;
    }

    function airdrop() public {
        require(!addressReceived[msg.sender]);
        require(token.transfer(msg.sender, amountOfTokens));
        addressReceived[msg.sender] = true;
        airdropsCount++;
        totalClaimed = totalClaimed.add(amountOfTokens);
    }

    function returnTokens() public onlyOwner {
        require(token.transfer(owner(), getRemainingTokens()));
    }

    function burnRemainingTokens() public onlyOwner {
        require(token.transfer(burnAddress, getRemainingTokens()));
    }

    function getRemainingTokens() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        token = ERC20(_tokenAddress);
    }

    function setTokenAmount(uint256 _amount) public onlyOwner {
        amountOfTokens = _amount;
    }
}
