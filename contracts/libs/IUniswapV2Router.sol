// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IUniswapV2Router {
  function factory() external view returns (address);
  function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
}

contract UniswapV2RouterMock is IUniswapV2Router {
  address factoryAddress;

  constructor(address _factoryAddress) {
    factoryAddress = _factoryAddress;
  }

  function factory() external view returns (address) {
    return factoryAddress;
  }

  function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity) {
    return (1, 1, 1);
  }
}
