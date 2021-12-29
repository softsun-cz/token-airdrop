const Token = artifacts.require("Token");
const Airdropper = artifacts.require("Airdropper");

module.exports = async function(deployer) {
  const name = "Test token";
  const symbol = "TEST";
  const supply = 100000000;
  const decimals = 18;
  const airdrop = 1000;
  await deployer.deploy(Token, name, symbol, supply, decimals);
  await Token.deployed();
  await deployer.deploy(Airdropper, airdrop, decimals);
};
