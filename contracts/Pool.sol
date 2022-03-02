// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Pool is Ownable, ReentrancyGuard {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;
  mapping(uint256 => mapping(address => UserInfo)) public users; // Info of each user that stakes tokens.
  PoolInfo[] public pools; // Info of each user that stakes tokens.
  address public devFeeAddress;
  bool started = false;
  event eventDeposit(
    address indexed user,
    uint256 indexed poolID,
    uint256 amount
  );
  event eventWithdraw(
    address indexed user,
    uint256 indexed poolID,
    uint256 amount
  );
  event eventEmergencyWithdraw(
    address indexed user,
    uint256 indexed poolID,
    uint256 amount
  );
  event eventSetDevFeeAddress(
    address indexed user,
    address indexed devFeeAddress
  );

  struct UserInfo {
    uint256 amount;
    uint256 rewardDebt;
  }

  struct PoolInfo {
    IERC20 tokenDeposit;
    IERC20 tokenEarn;
    uint256 tokensEarnPerBlock;
    uint256 lastRewardBlock;
    uint256 accTokenPerShare;
    uint256 feeDeposit;
  }

  constructor(address _devFeeAddress) {
    setDevFeeAddress(_devFeeAddress);
  }

  function pendingTokens(uint256 _poolID, address _userAddress)
    external
    view
    returns (uint256)
  {
    PoolInfo storage pool = pools[_poolID];
    UserInfo storage user = users[_poolID][_userAddress];
    uint256 accTokenPerShare = pool.accTokenPerShare;
    uint256 supply = pool.tokenDeposit.balanceOf(address(this));
    if (block.number > pool.lastRewardBlock && supply != 0) {
      uint256 multiplier = block.number.sub(pool.lastRewardBlock);
      accTokenPerShare = accTokenPerShare.add(
        multiplier.mul(pool.tokensEarnPerBlock).mul(1e12).div(supply)
      );
    }
    return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
  }

  function updateAllPools() public {
    for (uint256 poolID = 0; poolID < pools.length; poolID++)
      updatePool(poolID);
  }

  function updatePool(uint256 _poolID) public {
    PoolInfo storage pool = pools[_poolID];
    if (block.number <= pool.lastRewardBlock) return;
    uint256 supply = pool.tokenDeposit.balanceOf(address(this));
    if (supply == 0 || !started) {
      pool.lastRewardBlock = block.number;
      return;
    }
    uint256 multiplier = block.number.sub(pools[_poolID].lastRewardBlock);
    pool.accTokenPerShare = pool.accTokenPerShare.add(
      multiplier.mul(1e12).div(supply)
    );
    pool.lastRewardBlock = block.number;
  }

  function deposit(uint256 _poolID, uint256 _amount) public nonReentrant {
    // require(started, "deposit: Staking not started yet.");
    PoolInfo storage pool = pools[_poolID];
    UserInfo storage user = users[_poolID][msg.sender];
    updatePool(_poolID);
    if (user.amount > 0) {
      uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(
        user.rewardDebt
      );
      if (pending > 0)
        safeTokenTransfer(address(pool.tokenEarn), msg.sender, pending);
    }
    if (_amount > 0) {
      pool.tokenDeposit.safeTransferFrom(msg.sender, address(this), _amount);
      if (pool.feeDeposit > 0) {
        uint256 depositFee = _amount.mul(pool.feeDeposit).div(10000);
        pool.tokenDeposit.safeTransfer(devFeeAddress, depositFee);
        user.amount = user.amount.add(_amount).sub(depositFee);
      } else user.amount = user.amount.add(_amount);
    }
    user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
    emit eventDeposit(msg.sender, _poolID, _amount);
  }

  function withdraw(uint256 _poolID, uint256 _amount) public nonReentrant {
    PoolInfo storage pool = pools[_poolID];
    UserInfo storage user = users[_poolID][msg.sender];
    require(user.amount >= _amount, "withdraw: Amount is too big");
    updatePool(_poolID);
    uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(
      user.rewardDebt
    );
    if (pending > 0)
      safeTokenTransfer(address(pool.tokenEarn), msg.sender, pending);
    if (_amount > 0) {
      user.amount = user.amount.sub(_amount);
      pool.tokenDeposit.safeTransfer(address(msg.sender), _amount);
    }
    user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
    emit eventWithdraw(msg.sender, _poolID, _amount);
  }

  function emergencyWithdraw(uint256 _poolID) public nonReentrant {
    PoolInfo storage pool = pools[_poolID];
    UserInfo storage user = users[_poolID][msg.sender];
    uint256 amount = user.amount;
    user.amount = 0;
    user.rewardDebt = 0;
    pool.tokenDeposit.safeTransfer(address(msg.sender), amount);
    emit eventEmergencyWithdraw(msg.sender, _poolID, amount);
  }

  function safeTokenTransfer(
    address _tokenAddress,
    address _toAddress,
    uint256 _amount
  ) internal {
    IERC20 token = IERC20(_tokenAddress);
    uint256 tokenBal = token.balanceOf(address(this));
    bool transferSuccess = false;
    if (_amount > tokenBal)
      transferSuccess = token.transfer(_toAddress, tokenBal);
    else transferSuccess = token.transfer(_toAddress, _amount);
    require(transferSuccess, "safeTokenTransfer: transfer failed");
  }

  function createPool(
    address _tokenDepositAddress,
    address _tokenEarnAddress,
    uint256 _tokensEarnPerBlock,
    uint16 _feeDeposit
  ) public onlyOwner {
    pools.push(
      PoolInfo(
        IERC20(_tokenDepositAddress),
        IERC20(_tokenEarnAddress),
        _tokensEarnPerBlock,
        block.number,
        0,
        _feeDeposit
      )
    );
  }

  function start() public onlyOwner {
    updateAllPools();
    started = true;
  }

  function setDevFeeAddress(address _devFeeAddress) public onlyOwner {
    devFeeAddress = _devFeeAddress;
    emit eventSetDevFeeAddress(msg.sender, _devFeeAddress);
  }
}
