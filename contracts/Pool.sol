// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

// TODO: zjistit, k cemu je u eventu indexed
// TODO: nize dalsi TODO

contract Pool is Ownable, ReentrancyGuard {
    PoolInfo public pool; // Info of our pool
    mapping(address => UserInfo) public users; // Info of each user that stakes tokens.
    mapping(address => PoolInfo) public pools; // Info of each user that stakes tokens.
    uint256 public startBlock; // The block number when token staking starts.
    event eventDeposit(address indexed user, uint256 poolID, uint256 amount);
    event eventWithdraw(address indexed user, uint256 poolID, uint256 amount);
    event eventEmergencyWithdraw(address indexed user, uint256 poolID, uint256 amount);

    struct UserInfo {
        uint256 amount;           // How many tokens the user has provided.
        uint256 rewardDebt;       // Reward debt. See explanation below.
    }

    struct PoolInfo {
        IERC20 tokenDeposit;
        IERC20 tokenEarn;
        uint256 lastRewardBlock;  // Last block number that Tokens distribution occurs.
        uint256 accTokenPerShare; // Accumulated tokens per share, times 10**12. See below.
    }

    constructor(uint256 _startBlock) {
        startBlock = _startBlock;
    }

    function createPool(address _tokenDepositAddress, address _tokenEarnAddress, uint256 _tokensEarnPerBlock, uint16 _fee) public onlyOwner {
        pool = PoolInfo();
        pool.tokenDeposit = IERC20(_tokenDepositAddress);
        pool.tokenEarn = IERC20(_tokenEarnAddress);
        pool.tokensEarnPerBlock = _tokensEarnPerBlock;
        pool.lastRewardBlock = block.number;
        pool.fee = _fee;
        pool.accTokenPerShare = 0;
        pools.push(pool);
    }

    // View function to see pending tokens on frontend.
    function pendingTokens(uint256 _poolID, address _user) public view returns (uint256) {
        UserInfo storage user = users[_user];
        uint256 accTokenPerShare = pools[_poolID].accTokenPerShare;
        uint256 supply = pools[_poolID].token.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && supply != 0) {
            uint256 multiplier =  block.number - pool.lastRewardBlock;
            accTokenPerShare += (multiplier * pools[_poolID].tokensEarnPerBlock) * 10**12 / supply;
        }
        return user.amount * accTokenPerShare / 10**12 - user.rewardDebt;
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _poolID) public {
        if (block.number <= pools[_poolID].lastRewardBlock) return;
        uint256 supply = pools[_poolID].token.balanceOf(address(this));
        if (supply == 0) {
            pools[_poolID].lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = block.number - pools[_poolID].lastRewardBlock;
        // TODO: Prepay this contract with some tokens and add lines checking that there still enough tokens in contract instead of minting.
        // TODO: check if we have enough tokens in contract
        //token.mint(address(this), tokenReward);
        pools[_poolID].accTokenPerShare += (multiplier * pools[_poolID].tokensEarnPerBlock) * 10**12 / supply;
        pools[_poolID].lastRewardBlock = block.number;
    }

    // Deposit tokens to Pool for token allocation.
    function deposit(uint256 _poolID, uint256 _amount) public nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        updatePool(_poolID);
        if (user.amount > 0) {
            uint256 pending = user.amount * pools[_poolID].accTokenPerShare / 10**12 - user.rewardDebt;
            if (pending > 0) safeTokenTransfer(msg.sender, pending);
        }
        if (_amount > 0) {
            pools[_poolID].token.transferFrom(address(msg.sender), address(this), _amount);
            user.amount = user.amount + _amount;
        }
        user.rewardDebt = user.amount * pools[_poolID].accTokenPerShare / 10**12;
        emit eventDeposit(msg.sender, _poolID, _amount);
    }

    // Withdraw tokens from Pool.
    function withdraw(uint256 _poolID, uint256 _amount) public nonReentrant {
        UserInfo storage user = users[msg.sender];
        require(user.amount >= _amount, 'withdraw: Amount is too big');
        updatePool(_poolID);
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
    function emergencyWithdraw(uint256 _poolID) public nonReentrant {
        UserInfo storage user = users[msg.sender];
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        pools[_poolID].token.transfer(address(msg.sender), amount);
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
