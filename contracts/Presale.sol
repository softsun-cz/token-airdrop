// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Presale is Ownable, ReentrancyGuard {
    uint256 public devFeePercent = 50;
    uint256 public startTime;
    uint256 public depositTimeOut;
    uint256 public claimTimeOut;
    uint256 public depositedCount;
    uint256 public claimedCount;
    uint256 public tokenPrice;
    uint256 public totalDeposited;
    uint256 public totalClaimed;
    uint256 public totalClaimable;
    ERC20 public tokenOur;
    ERC20 public tokenTheir;
    address public devAddress;
    // address public routerAddress;
    address burnAddress = 0x000000000000000000000000000000000000dEaD;
    address zeroAddress = 0x0000000000000000000000000000000000000000;
    mapping (address => uint256) public deposited;
    mapping (address => uint256) public claimed;
    mapping (address => uint256) public claimable;
    event eventDeposited(address sender, uint256 amount);
    event eventClaimed(address sender, uint256 amount);
    event eventSetTokenOurAddress(address tokenAddress);
    event eventSetTokenTheirAddress(address tokenAddress);
    event eventSetTokenPrice(uint256 price);
    event eventSetDevAddress(address devAddress);
    event eventBurnRemainingTokens(uint256 amount);

    bool liquidityCreated = false;

    constructor() {
        // routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // pancakeswap.finance (BSC Mainnet)
        // routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3; // pancake.kiemtienonline360.com (BSC Testnet)
        // routerAddress = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; // quickswap.exchange (Polygon Mainnet)
        startTime = block.timestamp;
        depositTimeOut = startTime + 1 days;
        claimTimeOut = depositTimeOut + 14 days;
        devAddress = owner();

        // TODO: DELETE THIS AFTER TESTS ARE OVER!!!
        tokenOur = ERC20(0xAD531A13b61E6Caf50caCdcEebEbFA8E6F5Cbc4D);
        tokenTheir = ERC20(0xF42a4429F107bD120C5E42E069FDad0AC625F615);
        tokenPrice = 1000000000000000;
        devAddress = 0x650E5c6071f31065d7d5Bf6CaD5173819cA72c41;
    }

    function deposit(uint256 _amount) public nonReentrant {
        uint256 allowance = tokenTheir.allowance(msg.sender, address(this));
        require(allowance >= _amount, 'deposit: Allowance is too low');
        require(block.timestamp <= depositTimeOut, 'deposit: Deposit period already timed out');
        uint256 toClaim = (_amount * 10**tokenTheir.decimals()) / tokenPrice;
        require(totalClaimable + toClaim <= getRemainableTokens(), 'deposit: Not enough tokens in this contract');
        require(tokenTheir.transferFrom(msg.sender, address(this), _amount));
        require(tokenTheir.transfer(address(devAddress), _amount * devFeePercent / 100)); // devFeePercent% of tokenTheir deposited here goes to devAddress, the rest stays in this contract
        deposited[msg.sender] += _amount;
        claimable[msg.sender] += toClaim;
        totalDeposited += _amount;
        totalClaimable += toClaim;
        emit eventDeposited(msg.sender, _amount);
    }

    function claim() public nonReentrant {
        require(block.timestamp > depositTimeOut, 'claim: Deposit period did not timed out yet');
        require(block.timestamp <= claimTimeOut, 'claim: Claim period already timed out');
        if (!liquidityCreated) createLiquidity(); // the first person who runs claim() after depositTimeOut also creates liquidity
        uint256 amount = claimable[msg.sender];
        require(tokenOur.transfer(msg.sender, amount));
        claimed[msg.sender] += amount;
        claimable[msg.sender] -= amount;
        totalClaimed += amount;
        totalClaimable -= amount;
        emit eventClaimed(msg.sender, amount);
    }

    function getRemainingTokens() public view returns (uint256) {
        return tokenOur.balanceOf(address(this));
    }

    function getRemainableTokens() public view returns (uint256) {
        return getRemainingTokens() - totalClaimable;
    }

    function setTokenOurAddress(address _tokenAddress) public onlyOwner {
        require(address(tokenOur) == zeroAddress, 'setTokenOurAddress: tokenOur can be set only once');
        tokenOur = ERC20(_tokenAddress);
        emit eventSetTokenOurAddress(_tokenAddress);
    }

    function setTokenTheirAddress(address _tokenAddress) public onlyOwner {
        require(address(tokenTheir) == zeroAddress, 'setTokenTheirAddress: tokenTheir can be set only once');
        tokenTheir = ERC20(_tokenAddress);
        emit eventSetTokenTheirAddress(_tokenAddress);
    }

    function setTokenPrice(uint256 _price) public onlyOwner {
        require(tokenPrice == 0, 'setTokenPrice: tokenPrice can be set only once');
        tokenPrice = _price;
        emit eventSetTokenPrice(_price);
    }

    function setDevAddress(address _devAddress) public onlyOwner {
        devAddress = _devAddress;
        emit eventSetDevAddress(_devAddress);
    }

    function createLiquidity() private { // the first person who runs claim() after depositTimeOut also creates liquidity
        require(block.timestamp > depositTimeOut, 'createLiquidity: Deposit period did not timed out yet');
        require(!liquidityCreated, 'createLiquidity: Liquidity was created already before');

        // TODO:
        // - move remaining tokenTheir (stored in this contract address) to liquidity
        //   somehow using router / factory address with specified price
        //   for example:
        //   Amount of tokenTheir in this contract: 1 000 TOK
        //   Amount of tokenOur in this contract: some huge number (bilions) of TOK2
        //   Price of TOK2 = 0.001
        //   Add to liquidity 1 000 TOK + 1 000 000 TOK2
        //   After that burn remaining TOK2 in this contract, but reserve these 1 000 000 and number of tokens people can claim
        //   (which means there will be 0 TOK2 after everyone will claim their tokens)

        liquidityCreated = true;
    }

    function burnRemainingTokens() public { // to be fair anyone can start it after claimTimeout
        require(block.timestamp > claimTimeOut, 'burnRemainingTokens: Claim period did not timed out yet');
        uint256 remaining = getRemainingTokens();
        require(tokenOur.transfer(burnAddress, remaining));
        emit eventBurnRemainingTokens(remaining);
    }
}
