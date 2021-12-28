const Token = artifacts.require("Token");
const Airdropper = artifacts.require("Airdropper");

module.exports = async function(deployer) {
  await deployer.deploy(Token, "Test Token", "TEST", 1000000000000000000000000000);
  await Token.deployed();
  await deployer.deploy(Airdropper, 1000000000000000000000);
};
