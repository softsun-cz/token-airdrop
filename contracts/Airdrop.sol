// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract Airdrop is Ownable, ReentrancyGuard {
    uint256 public totalClaimed;
    uint256 public amountToClaim;
    uint256 public claimCount;
    address burnAddress = 0x000000000000000000000000000000000000dEaD;
    mapping (address => bool) public addressReceived;
    ERC20 public token;

    function claim() public nonReentrant {
        require(!addressReceived[msg.sender]);
        require(token.transfer(msg.sender, amountToClaim));
        addressReceived[msg.sender] = true;
        claimCount++;
        totalClaimed += amountToClaim;
    }

    function returnRemainingTokensToOwner() public nonReentrant onlyOwner {
        require(token.transfer(owner(), getRemainingTokens()));
    }

    function burnRemainingTokens() public nonReentrant onlyOwner {
        require(token.transfer(burnAddress, getRemainingTokens()));
    }

    function getRemainingTokens() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        token = ERC20(_tokenAddress);
    }

    function setAmountToClaim(uint256 _amount) public onlyOwner {
        amountToClaim = _amount;
    }
}
