// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Pool is Ownable, ReentrancyGuard {
    IERC20 public token;
    uint256 public tokensPerBlock;
    PoolInfo public pool; // Info of our pool
    mapping(address => UserInfo) public userInfo; // Info of each user that stakes tokens.
    uint256 public startBlock = block.number; // The block number when token mining starts.
    event eventDeposit(address indexed user, uint256 amount);
    event eventWithdraw(address indexed user, uint256 amount);
    event eventEmergencyWithdraw(address indexed user, uint256 amount);

    struct UserInfo {
        uint256 amount;           // How many tokens the user has provided.
        uint256 rewardDebt;       // Reward debt. See explanation below.
    }

    struct PoolInfo {
        IERC20 token;              // Address of token contract.
        uint256 lastRewardBlock;  // Last block number that Tokens distribution occurs.
        uint256 accTokenPerShare; // Accumulated tokens per share, times 10**12. See below.
    }

    constructor(address _tokenAddress, uint256 _tokensPerBlock) {
        token = IERC20(_tokenAddress);
        tokensPerBlock = _tokensPerBlock;
        pool.token = IERC20(_tokenAddress);
        pool.lastRewardBlock = block.number;
        pool.accTokenPerShare = 0;
    }

    // View function to see pending tokens on frontend.
    function pendingTokens(address _user) external view returns (uint256) {
        UserInfo storage user = userInfo[_user];
        uint256 accTokenPerShare = pool.accTokenPerShare;
        uint256 supply = pool.token.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && supply != 0) {
            uint256 multiplier =  block.number - pool.lastRewardBlock;
            accTokenPerShare = accTokenPerShare + ((multiplier * tokensPerBlock) * 10**12 / supply);
        }
        return user.amount * accTokenPerShare / 10**12 - user.rewardDebt;
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool() public {
        if (block.number <= pool.lastRewardBlock) return;
        uint256 supply = pool.token.balanceOf(address(this));
        if (supply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = block.number - pool.lastRewardBlock;
        // TODO: Prepay this contract with some tokens and add lines checking that there still enough tokens in contract instead of minting.
        //token.mint(address(this), tokenReward);
        pool.accTokenPerShare = pool.accTokenPerShare + (multiplier * tokensPerBlock) * 10**12 / supply;
        pool.lastRewardBlock = block.number;
    }

    // Deposit LP tokens to MasterChef for token allocation.
    function deposit(uint256 _amount) public nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        updatePool();
        if (user.amount > 0) {
            uint256 pending = user.amount * pool.accTokenPerShare / 10**12 - user.rewardDebt;
            if (pending > 0) safeTokenTransfer(msg.sender, pending);
        }
        if (_amount > 0) {
            pool.token.transferFrom(address(msg.sender), address(this), _amount);
            user.amount = user.amount + _amount;
        }
        user.rewardDebt = user.amount * pool.accTokenPerShare / 10**12;
        emit eventDeposit(msg.sender, _amount);
    }

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _amount) public nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        require(user.amount >= _amount, 'withdraw: Amount is too big');
        updatePool();
        uint256 pending = user.amount * pool.accTokenPerShare / 10**12 - user.rewardDebt;
        if (pending > 0) safeTokenTransfer(msg.sender, pending);
        if (_amount > 0) {
            user.amount = user.amount - _amount;
            pool.token.transfer(address(msg.sender), _amount);
        }
        user.rewardDebt = user.amount * pool.accTokenPerShare / 10**12;
        emit eventWithdraw(msg.sender, _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw() public nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        pool.token.transfer(address(msg.sender), amount);
        emit eventEmergencyWithdraw(msg.sender, amount);
    }

    // Safe token transfer function, just in case if rounding error causes pool to not have enough tokens.
    function safeTokenTransfer(address _to, uint256 _amount) internal {
        uint256 tokenBal = token.balanceOf(address(this));
        bool transferSuccess = false;
        if (_amount > tokenBal) transferSuccess = token.transfer(_to, tokenBal);
        else transferSuccess = token.transfer(_to, _amount);
        require(transferSuccess, 'safeTokenTransfer: transfer failed');
    }
}
