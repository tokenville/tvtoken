'use strict';

const TVCoupon = artifacts.require("./TVCoupon.sol");
const TVToken = artifacts.require("./TVToken.sol");

const conf = {
  'development': {
    TV_TOKEN: TVToken.networks['5777'] && TVToken.networks['5777'].address || '',
  },
  'ropsten': {
    TV_TOKEN: TVToken.networks['3'] && TVToken.networks['3'].address || '',
  },
  'kovan': {
    TV_TOKEN: TVToken.networks['42'] && TVToken.networks['42'].address || '',
  },
  'mainnet': {
  }
};

module.exports = function(deployer, network) {
  let params = conf[network];
  let allParamsSet = params.TV_TOKEN;
  console.log(params);
  if (allParamsSet)  {
    return deployer.deploy(
      TVCoupon,
      params.TV_TOKEN
    );
  }
  params.TV_TOKEN && console.error('TV_TOKEN is undefined.');
};

