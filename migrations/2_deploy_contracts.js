const Token = artifacts.require('Token');
const Presale = artifacts.require('Presale');
const Airdrop = artifacts.require('Airdrop');
const Pool = artifacts.require('Pool');

module.exports = async function(deployer) {
 const tokenOur = {address: '0x9b6452d8EE8B79605F3F73d04F5f43D7A9Df59A3'};
 const tokenUSD = {address: '0xF42a4429F107bD120C5E42E069FDad0AC625F615'};
 // const router = '0x10ED43C718714eb63d5aA57B78B54704E256024E'; // pancakeswap.finance (BSC Mainnet)
 // const router = '0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3'; // pancake.kiemtienonline360.com (BSC Testnet)
 // const router = '0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff'; // quickswap.exchange (Polygon Mainnet)
 const router = '0x8954AfA98594b838bda56FE4C12a09D7739D179b'; // quickswap.exchange (Polygon Testnet)
 const dev = '0x650E5c6071f31065d7d5Bf6CaD5173819cA72c41';
 const airdropAmount = '1000000000000000000'; // 1
 const airdropTime = 900; // 15 minutes
 const presalePricePresale = '1000000000000000000'; // 1 USD
 const presalePriceLiquidity = '2000000000000000000'; // 2 USD
 const presaleDepositTime = '600'; // 10 minutes
 const presaleClaimTime = '300'; // 5 minutes
 const presaleTokenOurTheirMax = '5000000000000000000000000'; // 5 000 000 USD
 const poolTokensOurPerBlock = '100000000000000000'; // 0.1 tokens / block
 const poolTokensUSDPerBlock = '200000000000000000'; // 0.2 tokens / block
 const poolTokensOurLPPerBlock = '300000000000000000'; // 0.3 tokens / block
 const tokenOurName = 'Test token';
 const tokenOurSymbol = 'TEST';
 const tokenOurSupply = 10000000; // 10 000 000 tokens
 const tokenOurDecimals = 18;
 const tokenOurBurnFee = 2;
 const tokenOurDevFee = 3;
 // const tokenLiquidityFee = 3; // TODO: not used yet

 // await deployer.deploy(Token, tokenOurName, tokenOurSymbol, tokenOurSupply, tokenOurDecimals, tokenOurDevFee, tokenOurBurnFee);
 // const tokenOur = await Token.deployed();
 // await deployer.deploy(Presale, tokenOur.address, tokenUSD, router, dev, presalePricePresale, presalePriceLiquidity, presaleDepositTime, presaleClaimTime, presaleTokenTheirMax);
 // const presale = await Presale.deployed();
 // await deployer.deploy(Airdrop, tokenOur.address, airdropAmount);
 // const airdrop = await Airdrop.deployed();
 await deployer.deploy(Pool, dev);
 const pool = await Pool.deployed();
 // airdrop.start(airdropTime);
 pool.createPool(tokenOur.address, tokenOur.address, poolTokensOurPerBlock, 0); // Our -> Our
 pool.createPool(tokenUSD.address, tokenOur.address, poolTokensUSDPerBlock, 400); // BUSD -> Our
 // TODO: get LP address from token
 //pool.createPool(tokenOurLPAddress, tokenOur.address, poolTokensOurLPPerBlock, 0); // Our-BUSD -> Our

 // TODO: THE FOLLOWING TOKEN FUNCTIONS WORK ONLY IF A NEW TOKEN IS DEPLOYED, NOT WITH JUST ADDRESS
 //tokenOur.setTaxExclusion(airdrop.address, true);
 //tokenOur.setTaxExclusion(presale.address, true);
 //tokenOur.transfer(presale.address, '7500000000000000000000000'); // 7 500 000
 //tokenOur.transfer(airdrop.address, '500000000000000000000000'); // 500 000
 //tokenOur.transfer(pool.address, '2000000000000000000000000'); // 2 000 000
};
