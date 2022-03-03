// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IUniswapV2Factory {
  event PairCreated(
    address indexed token0,
    address indexed token1,
    address pair,
    uint256
  );

  function getPair(address tokenA, address tokenB)
    external
    view
    returns (address pair);

  function createPair(address tokenA, address tokenB)
    external
    returns (address pair);
}

contract UniswapV2FactoryMock is IUniswapV2Factory {
  address private _lpTokenAddress;

  constructor(address lpTokenAddress) {
    _lpTokenAddress = lpTokenAddress;
  }

  function getPair(address tokenA, address tokenB)
    external
    view
    returns (address pair)
  {
    return _lpTokenAddress;
  }

  function createPair(address tokenA, address tokenB)
    external
    returns (address pair)
  {
    return _lpTokenAddress;
  }
}
