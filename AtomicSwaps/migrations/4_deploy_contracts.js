const SwapEtherToERC20 = artifacts.require("SwapEtherToERC20");

module.exports = function(deployer) {
  deployer.deploy(SwapEtherToERC20);

};
