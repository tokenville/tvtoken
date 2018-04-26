'use strict';

const TVToken = artifacts.require("./TVToken.sol");

module.exports = function(deployer) {
  return deployer.deploy(TVToken);
};
