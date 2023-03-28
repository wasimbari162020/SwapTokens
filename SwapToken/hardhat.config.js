require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');
require("dotenv").config();

let mnemonic = process.env.MNEMONIC;// fs.readFileSync(".secret").toString().trim();
let infuraProjectID = process.env.INFURA_PROJECT_ID ;//fs.readFileSync(".infura").toString().trim();
// console.log(mnemonic)
// console.log(infuraProjectID)

module.exports = {
  solidity: "0.7.6",
  networks: {
   
  },
  networks: {

     goerli: {
        url: "https://goerli.infura.io/v3/" + infuraProjectID,
        accounts: {
          mnemonic,
          path: "m/44'/60'/0'/0",
          initialIndex: 0,
          count: 20,
      },
     }
    // palm_testnet: {
    //   provider: () => new HDWalletProvider({
    //     providerOrUrl: `https://palm-testnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
    //     // privateKeys: [
    //     //   process.env.PRIVATE_KEY
    //     // ]
    //   }),
    //   network_id: 5, // chain ID
    //   gasPrice: 1000 // gas price in gwei
    // }
    

  }
  // etherscan: {
  //   apiKey: process.env.ETHERSCAN_KEY
  // }
}; // rinkeby: {
    //   url: process.env.RINKEBY_URL,
    //   accounts: [process.env.RINKEBY_PRIVATE_KEY]
    // }