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
    kovan: {
      provider() {
        return new PrivateKeyProvider(process.env.PRIVATE_KEY, "https://kovan.infura.io/")
      },
      gas: 4700000,
      gasPrice: 1000000000,
      network_id: 42
    },
    mainnet: {
      provider() {
        return new PrivateKeyProvider(process.env.PRIVATE_KEY, "https://mainnet.infura.io/")
      },
      gas: 4700000,
      gasPrice: 10000000000,
      network_id: 1
    }
  }
};