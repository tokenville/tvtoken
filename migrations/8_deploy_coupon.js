'use strict';

const TVCoupon = artifacts.require("./TVCoupon.sol");

module.exports = function(deployer) {
  return deployer.deploy(TVCoupon);
};
