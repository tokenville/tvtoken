'use strict';

const PrivateKeyProvider = require("truffle-privatekey-provider");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*"
    },
    ropsten: {
      provider() {
        return new PrivateKeyProvider(process.env.PRIVATE_KEY, "https://ropsten.infura.io/")
      },
      gas: 4700000,
      gasPrice: 100000000000,
      network_id: 3
    },
    mainnet: {
      provider() {
        return new PrivateKeyProvider(process.env.PRIVATE_KEY, "https://api.myetherapi.com/eth")
      },
      gas: 2700000,
      gasPrice: 10000000000,
      network_id: 1
    }
  }
};