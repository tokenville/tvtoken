'use strict';

const TVCoupon = artifacts.require("./TVCoupon.sol");
const TVToken = artifacts.require("./TVToken.sol");

module.exports = function(deployer, network) {
    return deployer.deploy(
      TVCoupon,
      TVToken.address
    );
};

