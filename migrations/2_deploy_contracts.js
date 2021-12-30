// const Token = artifacts.require("Token");
const TokenTax = artifacts.require("TokenTax");
const Airdropper = artifacts.require("Airdropper");

module.exports = async function(deployer) {
  // await deployer.deploy(Token);
  await deployer.deploy(TokenTax);
  // await Token.deployed();
  await TokenTax.deployed();
  await deployer.deploy(Airdropper);
};
