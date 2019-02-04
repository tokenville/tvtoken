'use strict';

const RATE = "200";

const TVCrowdsale = artifacts.require("./TVCrowdsale.sol");
const TVToken = artifacts.require("./TVToken.sol");

const wallet = '0x120ceddf37ed9704f8f3f226d4d85caa4ef20b63';
const manager = '0x1feD8Ba9A9FDd72EF9038046ad148bEb413491b8';
let token_wallet = '0x09570e69ADDD835a71bd19a5104656e0Da38fD84';

module.exports = function(deployer, network, accounts) {
  if (network === 'development') {
    token_wallet = '0xA720f241d13F2AE8ACffa45cbcDBe3879276A6a3';
  }
  return deployer.deploy(TVCrowdsale, RATE, wallet, TVToken.address, token_wallet, manager);
};
