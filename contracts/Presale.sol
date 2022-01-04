// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Presale is Ownable {
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
    // address public routerAddress;
    address burnAddress;
    address zeroAddress;
    mapping (address => uint256) public deposited;
    mapping (address => uint256) public claimed;
    event eventDeposited(uint256 amount);
    event eventClaimed(uint256 amount);
    bool liquidityCreated;

    constructor() {
        // routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // pancakeswap.finance (BSC Mainnet)
        // routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3; // pancake.kiemtienonline360.com (BSC Testnet)
        // routerAddress = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; // quickswap.exchange (Polygon Mainnet)
        liquidityCreated = false;
        depositedCount = 0;
        claimedCount = 0;
        devAddress = owner();
        burnAddress = 0x000000000000000000000000000000000000dEaD;
        zeroAddress = 0x0000000000000000000000000000000000000000;
        startTime = block.timestamp;
        depositTimeOut = startTime + 1 days;
        claimTimeOut = depositTimeOut + 14 days;
        devFeePercent = 50;

        // TODO: DELETE THIS AFTER TESTS ARE OVER!!!
        setTokenOurAddress(0xAD531A13b61E6Caf50caCdcEebEbFA8E6F5Cbc4D);
        setTokenTheirAddress(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setTokenPrice(1000000000000000);
    }

    function deposit(uint256 _amount) public {
        uint256 allowance = tokenTheir.allowance(msg.sender, address(this));
        require(allowance >= _amount, "deposit: Allowance is too low");
        require(block.timestamp <= depositTimeOut, "deposit: Deposit period already timed out");
        require((totalDeposited + _amount) * tokenPrice <= getRemainingTokens(), "deposit: Not enough tokens in this contract");
        require(tokenTheir.transferFrom(msg.sender, address(this), _amount));
        require(tokenTheir.transfer(address(devAddress), _amount / (1 / devFeePercent) * 100)); // 50% of tokenTheir deposited here goes to devAddress, the rest stays in this contract
        deposited[msg.sender] = deposited[msg.sender] + _amount;
        totalDeposited = totalDeposited + _amount;
        emit eventDeposited(_amount);
    }

    function claim() public {
        require(block.timestamp > depositTimeOut, "claim: Deposit time did not timed out yet.");
        require(block.timestamp <= claimTimeOut, "claim: Claim period already timed out");
        if (!liquidityCreated) createLiquidity(); // the first person who runs claim() after depositTimeOut also creates liquidity
        uint256 amount = ((10**tokenTheir.decimals()) / tokenPrice) * tokenTheir.balanceOf(address(this));
        require(tokenOur.transfer(msg.sender, amount));
        claimed[msg.sender] = claimed[msg.sender] + amount;
        totalClaimed = totalClaimed + amount;
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

    function createLiquidity() private { // the first person who runs claim() after depositTimeOut also creates liquidity
        require(block.timestamp > depositTimeOut && !liquidityCreated);

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
        require(block.timestamp > claimTimeOut);
        require(tokenOur.transfer(burnAddress, getRemainingTokens()));
    }
}
