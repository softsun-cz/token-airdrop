// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IUniswapV2Router {
  function factory() external view returns (address);

  function addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  )
    external
    returns (
      uint256 amountA,
      uint256 amountB,
      uint256 liquidity
    );
}

contract UniswapV2RouterMock is IUniswapV2Router {
  address private _factoryAddress;
  address private _tokenA;
  address private _tokenB;
  uint256 private _amountADesired;
  uint256 private _amountBDesired;
  uint256 private _amountAMin;
  uint256 private _amountBMin;
  address private _to;
  uint256 private _deadline;

  constructor(address factoryAddress) {
    _factoryAddress = factoryAddress;
  }

  function factory() external view returns (address) {
    return _factoryAddress;
  }

  function addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  )
    external
    returns (
      uint256 amountA,
      uint256 amountB,
      uint256 liquidity
    )
  {
    _tokenA = tokenA;
    _tokenB = tokenB;
    _amountADesired = amountADesired;
    _amountBDesired = amountBDesired;
    _amountAMin = amountAMin;
    _amountBMin = amountBMin;
    _to = to;
    _deadline = deadline;
    return (1, 1, 1);
  }
}
