const Token = artifacts.require('Token');
const Presale = artifacts.require('Presale');
const Airdrop = artifacts.require('Airdrop');
const Pool = artifacts.require('Pool');

module.exports = async function(deployer) {
 const token = {address: '0xAD531A13b61E6Caf50caCdcEebEbFA8E6F5Cbc4D'};
 const tokenUSD = '0xF42a4429F107bD120C5E42E069FDad0AC625F615';
 // const router = '0x10ED43C718714eb63d5aA57B78B54704E256024E'; // pancakeswap.finance (BSC Mainnet)
 // const router = '0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3'; // pancake.kiemtienonline360.com (BSC Testnet)
 // const router = '0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff'; // quickswap.exchange (Polygon Mainnet)
 const router = '0x8954AfA98594b838bda56FE4C12a09D7739D179b'; // quickswap.exchange (Polygon Testnet)
 const dev = '0x650E5c6071f31065d7d5Bf6CaD5173819cA72c41';
 const airdropAmount = '1000000000000000000'; // 1
 const airdropTime = 300; // 5 minutes
 const presalePricePresale = '1000000000000000000'; // 1 USD
 const presalePriceLiquidity = '2000000000000000000'; // 2 USD
 const presaleDepositTime = '600'; // 10 minutes
 const presaleClaimTime = '900'; // 15 minutes
 const presaleTokenTheirMax = '500000000000000000000000'; // 500 000 USD
 const poolTokensPerBlock = '100000000000000000'; // 0.1 tokens / block
 const tokenName = 'Test token';
 const tokenSymbol = 'TEST';
 const tokenSupply = 100000000; // 100 M
 const tokenDecimals = 18;
 const tokenDevFee = 1;
 const tokenBurnFee = 2;

 // await deployer.deploy(Token, tokenName, tokenSymbol, tokenSupply, tokenDecimals, tokenDevFee, tokenBurnFee);
 // const token = await Token.deployed();
 await deployer.deploy(Presale, token.address, tokenUSD, router, dev, presalePricePresale, presalePriceLiquidity, presaleDepositTime, presaleClaimTime, presaleTokenTheirMax);
 const presale = await Presale.deployed();
 // await deployer.deploy(Airdrop, token.address, airdropAmount);
 // const airdrop = await Airdrop.deployed();
 // await deployer.deploy(Pool, token.address, poolTokensPerBlock);
 // const pool = await Pool.deployed();
 // airdrop.start(airdropTime);

 // TODO: THE FOLLOWING TOKEN FUNCTIONS WORK ONLY IF A NEW TOKEN IS DEPLOYED, NOT WITH JUST ADDRESS
 // token.setTaxExclusion(airdrop.address, true);
 // token.setTaxExclusion(presale.address, true);
 // token.transfer(presale.address, '98000000000000000000000000'); // 98 000 000
 // token.transfer(airdrop.address, '1000000000000000000000000'); // 1 000 000
 // token.transfer(pool.address, '1000000000000000000000000'); // 1 000 000
};
