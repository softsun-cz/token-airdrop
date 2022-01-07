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
    event eventClaimed(address sender, uint256 amount);
    event eventBurnRemainingTokens(uint256 amount);
    event eventSetAmountToClaim(uint256 amount);
    event eventSetTokenAddress(address amount);
    event eventReturnRemainingTokensToOwner(uint256 amount);

    function claim() public nonReentrant {
        require(!addressReceived[msg.sender]);
        require(token.transfer(msg.sender, amountToClaim));
        addressReceived[msg.sender] = true;
        claimCount++;
        totalClaimed += amountToClaim;
        emit eventClaimed(msg.sender, amountToClaim);
    }

    function returnRemainingTokensToOwner() public nonReentrant onlyOwner {
        uint256 remaining = getRemainingTokens();
        require(token.transfer(owner(), remaining));
        emit eventReturnRemainingTokensToOwner(remaining);
    }

    function burnRemainingTokens() public nonReentrant onlyOwner {
        uint256 remaining = getRemainingTokens();
        require(token.transfer(burnAddress, remaining));
        emit eventBurnRemainingTokens(remaining);
    }

    function getRemainingTokens() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        token = ERC20(_tokenAddress);
        emit eventSetTokenAddress(_tokenAddress);
    }

    function setAmountToClaim(uint256 _amount) public onlyOwner {
        amountToClaim = _amount;
        emit eventSetAmountToClaim(_amount);
    }
}
