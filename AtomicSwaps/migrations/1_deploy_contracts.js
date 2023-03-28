const SwapERC20ToBitcoin = artifacts.require("SwapERC20ToBitcoin");

module.exports = function(deployer) {
  deployer.deploy(SwapERC20ToBitcoin);

};
