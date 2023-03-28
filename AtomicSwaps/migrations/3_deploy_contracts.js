const SwapEtherToBitcoin = artifacts.require("SwapEtherToBitcoin");

module.exports = function(deployer) {
  deployer.deploy(SwapEtherToBitcoin);

};
