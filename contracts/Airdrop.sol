// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop is Ownable, ReentrancyGuard {
  uint256 public totalClaimed;
  uint256 public amountToClaim;
  uint256 public claimCount;
  uint256 public timeOut;
  address burnAddress;
  uint256 public minBaseCoinBalance;
  mapping(address => bool) public addressReceived;
  IERC20 public token;
  event eventClaimed(address sender, uint256 amount);
  event eventBurnRemainingTokens(uint256 amount);
  event eventSetAmountToClaim(uint256 amount);
  event eventSetTokenAddress(address amount);

  constructor(
    address _tokenAddress,
    address _burnAddress,
    uint256 _amountToClaim,
    uint256 _minBaseCoinBalance
  ) {
    token = IERC20(_tokenAddress);
    burnAddress = _burnAddress;
    amountToClaim = _amountToClaim;
    minBaseCoinBalance = _minBaseCoinBalance;
  }

  function claim() public nonReentrant {
    require(timeOut != 0, "claim: Airdrop has not started yet");
    require(timeOut > block.timestamp, "claim: Airdrop has ended already");
    require(
      !addressReceived[msg.sender],
      "claim: Your address have already claimed your tokens"
    );
    require(
      msg.sender.balance >= minBaseCoinBalance,
      "claim: Your wallet address does not have enough base coin"
    );
    require(token.transfer(msg.sender, amountToClaim));
    addressReceived[msg.sender] = true;
    claimCount++;
    totalClaimed += amountToClaim;
    emit eventClaimed(msg.sender, amountToClaim);
  }

  function start(uint256 timeSeconds) public nonReentrant onlyOwner {
    require(timeOut == 0, "start: Airdrop has already started");
    timeOut = block.timestamp + timeSeconds;
  }

  function burnRemainingTokens() public {
    // to be fair anyone can burn remaining tokens when airdrop is over
    require(timeOut != 0, "burnRemainingTokens: Airdrop has not started yet");
    require(
      timeOut < block.timestamp,
      "burnRemainingTokens: Airdrop has not ended yet"
    );
    uint256 remaining = getRemainingTokens();

    require(token.transfer(burnAddress, remaining));
    emit eventBurnRemainingTokens(remaining);
  }

  function getRemainingTokens() public view returns (uint256) {
    return token.balanceOf(address(this));
  }

  function setTokenAddress(address _tokenAddress) public onlyOwner {
    token = IERC20(_tokenAddress);
    emit eventSetTokenAddress(_tokenAddress);
  }

  function setAmountToClaim(uint256 _amount) public onlyOwner {
    amountToClaim = _amount;
    emit eventSetAmountToClaim(_amount);
  }
}
