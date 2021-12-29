const Token = artifacts.require("Token");
// const Airdropper = artifacts.require("Airdropper");

module.exports = async function(deployer) {
  const decimals = 18;
  await deployer.deploy(Token, "Test Token", "TEST", 1000000000, decimals);
  // await Token.deployed();
  // await deployer.deploy(Airdropper, 1000, decimals);
};
