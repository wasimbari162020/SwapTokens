const SwapERC20ToERC20 = artifacts.require("SwapERC20ToERC20");

module.exports = function(deployer) {
  deployer.deploy(SwapERC20ToERC20);

};
