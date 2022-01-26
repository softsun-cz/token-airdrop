// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Airdrop is Ownable, ReentrancyGuard {
    uint public totalClaimed;
    uint public amountToClaim;
    uint public claimCount;
    uint public timeOut;
    address burnAddress = 0x000000000000000000000000000000000000dEaD;
    mapping (address => bool) public addressReceived;
    IERC20 public token;
    event eventClaimed(address sender, uint amount);
    event eventBurnRemainingTokens(uint amount);
    event eventSetAmountToClaim(uint amount);
    event eventSetTokenAddress(address amount);

    constructor(address _token, uint _amountToClaim) {
        token = IERC20(_token);
        amountToClaim = _amountToClaim;
    }

    function claim() public nonReentrant {
        require(timeOut != 0, 'claim: Airdrop has not started yet');
        require(timeOut > block.timestamp, 'claim: Airdrop has ended already');
        require(!addressReceived[msg.sender]);
        require(token.transfer(msg.sender, amountToClaim));
        addressReceived[msg.sender] = true;
        claimCount++;
        totalClaimed += amountToClaim;
        emit eventClaimed(msg.sender, amountToClaim);
    }

    function start(uint timeSeconds) public nonReentrant onlyOwner {
        require(timeOut == 0, 'start: Airdrop has already started');
        timeOut = block.timestamp + timeSeconds;
    }

    function burnRemainingTokens() public { // to be fair anyone can burn remaining tokens when airdrop is over
        require(timeOut != 0, 'burnRemainingTokens: Airdrop has not started yet');
        require(timeOut < block.timestamp, 'burnRemainingTokens: Airdrop has not ended yet');
        uint remaining = getRemainingTokens();
        require(token.transfer(burnAddress, remaining));
        emit eventBurnRemainingTokens(remaining);
    }

    function getRemainingTokens() public view returns (uint) {
        return token.balanceOf(address(this));
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        token = IERC20(_tokenAddress);
        emit eventSetTokenAddress(_tokenAddress);
    }

    function setAmountToClaim(uint _amount) public onlyOwner {
        amountToClaim = _amount;
        emit eventSetAmountToClaim(_amount);
    }
}
