// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

contract Pool is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    mapping(uint256 => mapping(address => UserInfo)) public users; // Info of each user that stakes tokens.
    PoolInfo[] public pools; // Info of each user that stakes tokens.
    address public devFeeAddress;
    bool started = false;
    event eventDeposit(address indexed user, uint256 indexed poolID, uint256 amount);
    event eventWithdraw(address indexed user, uint256 indexed poolID, uint256 amount);
    event eventEmergencyWithdraw(address indexed user, uint256 indexed poolID, uint256 amount);
    event eventSetDevFeeAddress(address indexed user, address indexed devFeeAddress);

    struct UserInfo {
        uint256 amount; // How many tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
    }

    struct PoolInfo {
        IERC20 tokenDeposit;
        IERC20 tokenEarn;
        uint256 tokensEarnPerBlock;
        uint256 lastRewardBlock; // Last block number that Tokens distribution occurs.
        uint256 accTokenPerShare; // Accumulated tokens per share, times 10**12. See below.
        uint256 fee;
    }

    constructor(address _devFeeAddress) {
        setDevFeeAddress(_devFeeAddress);
    }

    // View function to see pending tokens on frontend.
    function pendingTokens(uint256 _poolID, address _userAddress) external view returns (uint256) {
        PoolInfo storage pool = pools[_poolID];
        UserInfo storage user = users[_poolID][_userAddress];
        uint256 accTokenPerShare = pool.accTokenPerShare;
        uint256 supply = pool.tokenDeposit.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && supply != 0) {
            uint256 multiplier =  block.number - pool.lastRewardBlock;
            accTokenPerShare += (multiplier * pool.tokensEarnPerBlock) * 10**12 / supply;
        }
        return user.amount * accTokenPerShare / 10**12 - user.rewardDebt;
    }

    function updateAllPools() public {
        for (uint256 poolID = 0; poolID < pools.length; ++poolID) updatePool(poolID);
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _poolID) public {
        PoolInfo storage pool = pools[_poolID];
        if (block.number <= pool.lastRewardBlock) return;
        uint256 supply = pool.tokenEarn.balanceOf(address(this));
        if (supply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = block.number - pools[_poolID].lastRewardBlock;
        // TODO: Prepay this contract with some tokens and add lines checking that there still enough tokens in contract instead of minting.

        // uint256 tokenReward = multiplier * tokenPerBlock;
        // token.mint(address(this), tokenReward);
        pool.accTokenPerShare += (multiplier * pool.tokensEarnPerBlock) * 10**12 / supply;
        pool.lastRewardBlock = block.number;
    }

    // Deposit tokens to Pool for token allocation.
    function deposit(uint256 _poolID, uint256 _amount) public nonReentrant {
        require(started, 'deposit: Staking not started yet.');
        PoolInfo storage pool = pools[_poolID];
        UserInfo storage user = users[_poolID][msg.sender];
        updatePool(_poolID);
        if (user.amount > 0) {
            uint256 pending = user.amount * pool.accTokenPerShare / 10**12 - user.rewardDebt;
            if (pending > 0) safeTokenTransfer(address(pool.tokenEarn), msg.sender, pending);
        }
        if (_amount > 0) {
            pool.tokenDeposit.safeTransferFrom(address(msg.sender), address(this), _amount);
            if (pool.fee > 0) {
                uint256 depositFee = _amount * pool.fee / 10000;
                pool.tokenDeposit.safeTransfer(devFeeAddress, depositFee);
                user.amount += _amount - depositFee;
            } else user.amount += _amount;
        }
        user.rewardDebt = user.amount * pool.accTokenPerShare / 10**12;
        emit eventDeposit(msg.sender, _poolID, _amount);
    }

    // Withdraw tokens from Pool.
    function withdraw(uint256 _poolID, uint256 _amount) public nonReentrant {
        PoolInfo storage pool = pools[_poolID];
        UserInfo storage user = users[_poolID][msg.sender];
        require(user.amount >= _amount, 'withdraw: Amount is too big');
        updatePool(_poolID);
        uint256 pending = user.amount * pool.accTokenPerShare / 10**12 - user.rewardDebt;
        if (pending > 0) safeTokenTransfer(address(pool.tokenEarn), msg.sender, pending);
        if (_amount > 0) {
            user.amount = user.amount - _amount;
            pool.tokenDeposit.safeTransfer(address(msg.sender), _amount);
        }
        user.rewardDebt = user.amount * pool.accTokenPerShare / 10**12;
        emit eventWithdraw(msg.sender, _poolID, _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(uint256 _poolID) public nonReentrant {
        PoolInfo storage pool = pools[_poolID];
        UserInfo storage user = users[_poolID][msg.sender];
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        pool.tokenDeposit.safeTransfer(address(msg.sender), amount);
        emit eventEmergencyWithdraw(msg.sender, _poolID, amount);
    }

    // Safe token transfer function, just in case if rounding error causes pool to not have enough tokens.
    function safeTokenTransfer(address _tokenAddress, address _to, uint256 _amount) internal {
        IERC20 token = IERC20(_tokenAddress);
        uint256 tokenBal = token.balanceOf(address(this));
        bool transferSuccess = false;
        if (_amount > tokenBal) transferSuccess = token.transfer(_to, tokenBal);
        else transferSuccess = token.transfer(_to, _amount);
        require(transferSuccess, 'safeTokenTransfer: transfer failed');
    }

    function createPool(address _tokenDepositAddress, address _tokenEarnAddress, uint256 _tokensEarnPerBlock, uint16 _fee) public onlyOwner {
        PoolInfo memory pool = PoolInfo(
            IERC20(_tokenDepositAddress),
            IERC20(_tokenEarnAddress),
            _tokensEarnPerBlock,
            0,
            0,
            _fee
        );
        pools.push(pool);
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
