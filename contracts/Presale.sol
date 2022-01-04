// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Presale is Ownable {
    using SafeMath for uint256;
    uint256 public depositedCount;
    uint256 public claimedCount;
    uint256 public tokenPrice;
    uint256 public totalDeposited;
    uint256 public totalClaimed;
    uint256 public startTime;
    uint256 public depositTimeOut;
    uint256 public claimTimeOut;
    ERC20 public tokenOur;
    ERC20 public tokenTheir;
    address public devAddress;
    address burnAddress;
    address zeroAddress;
    mapping (address => uint256) public deposited;
    mapping (address => uint256) public claimed;
    event eventDeposited(uint256 amount);
    event eventClaimed(uint256 amount);
    // address public routerAddress;

    constructor() {
        // routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // pancakeswap.finance (BSC Mainnet)
        // routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3; // pancake.kiemtienonline360.com (BSC Testnet)
        // routerAddress = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; // quickswap.exchange (Polygon Mainnet)
        depositedCount = 0;
        claimedCount = 0;
        devAddress = owner();
        burnAddress = 0x000000000000000000000000000000000000dEaD;
        zeroAddress = 0x0000000000000000000000000000000000000000;
        startTime = block.timestamp;
        depositTimeOut = startTime + 14 days;
        claimTimeOut = depositTimeOut + 14 days;
    }

    function deposit(uint256 _amount) public {
        uint256 allowance = tokenTheir.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");
        require(block.timestamp <= depositTimeOut);
        require((totalDeposited.add(_amount)).mul(tokenPrice) <= getRemainingTokens());
        require(tokenTheir.transfer(address(devAddress), _amount));
        // TODO: 90% of tokenTheir should go into liquidity (somehow thru router / factory address), the rest should go to devAddress. Now all goes to devAddress.
        uint256 dep = deposited[msg.sender];
        deposited[msg.sender] = dep.add(_amount);
        totalDeposited = totalDeposited.add(_amount);
        emit eventDeposited(_amount);
    }

    function claim() public {
        require(block.timestamp > depositTimeOut);
        require(block.timestamp <= claimTimeOut);
        uint256 amount = ((10**tokenTheir.decimals()).div(tokenPrice)).mul(tokenTheir.balanceOf(address(this)));
        require(tokenOur.transfer(msg.sender, amount));
        claimed[msg.sender] = claimed[msg.sender].add(amount);
        totalClaimed = totalClaimed.add(amount);
        emit eventClaimed(amount);
    }

    function getRemainingTokens() public view returns (uint256) {
        return tokenOur.balanceOf(address(this));
    }

    function setTokenOurAddress(address _tokenAddress) public onlyOwner {
        require(address(tokenOur) == zeroAddress);
        tokenOur = ERC20(_tokenAddress);
    }

    function setTokenTheirAddress(address _tokenAddress) public onlyOwner {
        require(address(tokenTheir) == zeroAddress);
        tokenTheir = ERC20(_tokenAddress);
    }

    function setTokenPrice(uint256 _price) public onlyOwner {
        require(tokenPrice == 0);
        tokenPrice = _price;
    }

    function setDevWallet(address _devAddress) public onlyOwner {
        devAddress = _devAddress;
    }

    function burnRemainingTokens() public onlyOwner {
        require(block.timestamp > claimTimeOut);
        require(tokenOur.transfer(burnAddress, getRemainingTokens()));
    }
}
