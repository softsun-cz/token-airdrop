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
    mapping (address => bool) public addressReceived;
    ERC20 public token;

    constructor() {
        totalClaimed = 0;
        amountOfTokens = 1000 * 10**18;
    }

    function airdrop(address memory _recipient) public {
        require(!addressReceived[_recipient]);
        require(token.transfer(_recipient, amountOfTokens));
        addressReceived[_recipient] = true;
        airdropsCount++;
        totalClaimed = totalClaimed.add(amountOfTokens);
    }

    function returnTokens() public onlyOwner {
        require(token.transfer(owner(), remainingTokens()));
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        token = ERC20(_tokenAddress);
    }

    function setTokenAmount(uint256 _amount) public onlyOwner {
        amountOfTokens = _amount;
    }

    function remainingTokens() public view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
