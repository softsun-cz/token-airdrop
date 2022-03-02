// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./LiquidityManager.sol";
import "./libs/IUniswapV2Router.sol";
import "./libs/IUniswapV2Factory.sol";

contract Presale is Ownable, ReentrancyGuard {
  ERC20 public tokenOur;
  ERC20 public tokenTheir;
  LiquidityManager public liquidityManager;
  uint256 public devFeePercent = 50;
  uint256 public startTime;
  uint256 public ownBalance;
  uint256 public depositTimeOut;
  uint256 public claimTimeOut;
  uint256 public depositedCount;
  uint256 public claimedCount;
  uint256 public tokenPricePresale;
  uint256 public tokenPriceLiquidity;
  uint256 public totalDeposited;
  uint256 public totalClaimed;
  uint256 public totalClaimable;
  uint256 public totalClaimableNotDeducted;
  address public devAddress;
  address public routerAddress;
  address burnAddress;
  mapping(address => uint256) public deposited;
  mapping(address => uint256) public claimed;
  mapping(address => uint256) public claimable;
  event eventDeposited(address sender, uint256 amount);
  event eventClaimed(address sender, uint256 amount);
  event eventSetTokenOurAddress(address tokenAddress);
  event eventSetTokenTheirAddress(address tokenAddress);
  event eventSetTokenPricePresale(uint256 price);
  event eventSetTokenPriceLiquidity(uint256 price);
  event eventSetDevAddress(address devAddress);
  event eventBurnRemainingTokens(uint256 amount);
  uint256 MAX_INT = 2**256 - 1;
  bool liquidityCreated = false;

  constructor(
    address _tokenOurAddress,
    address _tokenTheirAddress,
    address _routerAddress,
    address _devAddress,
    address _burnAddress,
    uint256 _tokenPricePresale,
    uint256 _tokenPriceLiquidity,
    uint256 _depositTime,
    uint256 _claimTime,
    LiquidityManager _liquidityManager
  ) {
    tokenOur = ERC20(_tokenOurAddress);
    tokenTheir = ERC20(_tokenTheirAddress);
    routerAddress = _routerAddress;
    tokenPricePresale = _tokenPricePresale;
    tokenPriceLiquidity = _tokenPriceLiquidity;
    devAddress = _devAddress;
    burnAddress = _burnAddress;
    startTime = block.timestamp;
    depositTimeOut = startTime + _depositTime;
    claimTimeOut = depositTimeOut + _claimTime;
    liquidityManager = _liquidityManager;
  }

  function deposit(uint256 _amount) public nonReentrant {
    uint256 allowance = tokenTheir.allowance(msg.sender, address(this));
    require(allowance >= _amount, "deposit: Allowance is too low");
    require(
      block.timestamp <= depositTimeOut,
      "deposit: Deposit period already timed out"
    );
    require(
      totalDeposited + _amount <= getPresaleTokenTheirMax(),
      "deposit: Maximum deposit amount exceeded."
    );
    uint256 toClaim = (_amount * 10**tokenTheir.decimals()) / tokenPricePresale;
    require(
      totalClaimable + toClaim <= getBalanceTokenOur(),
      "deposit: Not enough tokens in this contract"
    );
    require(tokenTheir.transferFrom(msg.sender, address(this), _amount));
    require(
      tokenTheir.transfer(address(devAddress), (_amount * devFeePercent) / 100)
    ); // devFeePercent% of tokenTheir deposited here goes to devAddress, the rest stays in this contract
    deposited[msg.sender] += _amount;
    claimable[msg.sender] += toClaim;
    totalDeposited += _amount;
    totalClaimable += toClaim;
    totalClaimableNotDeducted += toClaim;
    emit eventDeposited(msg.sender, _amount);
  }

  function depositOwn(uint256 _amount) public onlyOwner {
    uint256 allowance = tokenOur.allowance(msg.sender, address(this));
    require(allowance >= _amount, "depositOwn: Allowance is too low");
    require(tokenOur.transferFrom(msg.sender, address(this), _amount));
    ownBalance += _amount;
  }

  function claim() public nonReentrant {
    require(
      block.timestamp > depositTimeOut,
      "claim: Deposit period did not timed out yet"
    );
    require(
      block.timestamp <= claimTimeOut,
      "claim: Claim period already timed out"
    );
    if (!liquidityCreated) createLiquidity(); // the first person who runs claim() after depositTimeOut also creates liquidity
    uint256 amount = claimable[msg.sender];
    require(amount > 0, "claim: Nothing to claim");
    require(tokenOur.transfer(msg.sender, amount));
    claimed[msg.sender] += amount;
    claimable[msg.sender] -= amount;
    totalClaimed += amount;
    totalClaimable -= amount;
    emit eventClaimed(msg.sender, amount);
  }

  function createLiquidity() private {
    // the first person who runs claim() after depositTimeOut also creates liquidity
    require(
      block.timestamp > depositTimeOut,
      "createLiquidity: Deposit period did not timed out yet"
    );
    require(
      !liquidityCreated,
      "createLiquidity: Liquidity was created already before"
    );
    address pair = liquidityManager.getPairAddress(
      routerAddress,
      address(tokenOur),
      address(tokenTheir)
    );
    if (pair == address(0))
      pair = liquidityManager.createPair(
        routerAddress,
        address(tokenOur),
        address(tokenTheir)
      );
    require(pair != address(0), "createLiquidity: Cannot create token pair");
    uint256 allowanceOur = tokenOur.allowance(routerAddress, address(this));
    if (allowanceOur < MAX_INT) tokenOur.approve(routerAddress, MAX_INT);
    uint256 allowanceTheir = tokenTheir.allowance(routerAddress, address(this));
    if (allowanceTheir < MAX_INT) tokenTheir.approve(routerAddress, MAX_INT);
    require(
      getLiquidityTokenOur() > 0,
      "createLiquidity: amountOur must be more than 0"
    );
    require(
      getLiquidityTokenOur() <= getBalanceTokenOur(),
      "createLiquidity: Not enough balance of tokenOur to create a Liquidity"
    );
    IUniswapV2Router(routerAddress).addLiquidity(
      address(tokenOur),
      address(tokenTheir),
      getLiquidityTokenOur(),
      getLiquidityTokenTheir(),
      getLiquidityTokenOur(),
      getLiquidityTokenTheir(),
      burnAddress,
      block.timestamp + 1200
    );
    liquidityCreated = true;
  }

  function burnRemainingTokens() public {
    // to be fair anyone can start it after claimTimeout
    require(
      block.timestamp > claimTimeOut,
      "burnRemainingTokens: Claim period did not timed out yet"
    );
    uint256 remaining = getBalanceTokenOur();
    require(tokenOur.transfer(burnAddress, remaining));
    emit eventBurnRemainingTokens(remaining);
  }

  function getPresaleTokenTheirMax() public view returns (uint256) {
    // TODO: this works only for both tokens have the same number of decimals (18), should work also with tokens with different number of decimals
    uint256 totalOur = ownBalance;
    uint256 totalToPresaleOur = (totalOur * tokenPriceLiquidity) /
      (tokenPriceLiquidity + (tokenPricePresale * devFeePercent) / 100);
    return (totalToPresaleOur * tokenPricePresale) / 10**tokenOur.decimals();
  }

  function getLiquidityTokenOur() public view returns (uint256) {
    return
      (getLiquidityTokenTheir() * 10**tokenOur.decimals()) /
      tokenPriceLiquidity;
  }

  function getLiquidityTokenTheir() public view returns (uint256) {
    return (totalClaimableNotDeducted * (100 - devFeePercent)) / 100;
  }

  function getBalanceTokenOur() public view returns (uint256) {
    return tokenOur.balanceOf(address(this));
  }

  function getBalanceTokenTheir() public view returns (uint256) {
    return tokenTheir.balanceOf(address(this));
  }

  function setDevAddress(address _devAddress) public onlyOwner {
    devAddress = _devAddress;
    emit eventSetDevAddress(_devAddress);
  }
}
