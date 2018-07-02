'use strict';
const TVFreezeAirDrop = artifacts.require("./TVRefCrowdsale.sol");
const TVToken = artifacts.require("./TVToken.sol");
const TVCrowdsale = artifacts.require("./TVCrowdsale.sol");

const conf = {
  'development': {
    REF_PERCENTAGE: 1,
    TV_THRESHOLD: 500000000000000000000,
    HOLDER_ADDRESS: '0x340A4E26B5bA8ac4f9518A29E189F7b26F40F852'
  },
  'ropsten': {
    REF_PERCENTAGE: 1,
    TV_THRESHOLD: 500000000000000000000,
    HOLDER_ADDRESS: '0x7f6e3A92Bea716Aa332cF06b50FeC05980931096'
  },
  'mainnet': {
    REF_PERCENTAGE: null,
    TV_THRESHOLD: null,
    HOLDER_ADDRESS: null
  }
};

module.exports = function(deployer, network, accounts) {
  let params = conf[network];
  let allParamsSet = params.REF_PERCENTAGE && params.TV_THRESHOLD && params.HOLDER_ADDRESS;
  console.log(params);
  if (allParamsSet)  {
    return deployer.deploy(
      TVFreezeAirDrop,
      TVToken.address,
      TVCrowdsale.address,
      params.REF_PERCENTAGE,
      params.TV_THRESHOLD,
      params.HOLDER_ADDRESS
    );
  }
  params.REF_PERCENTAGE && console.error('REF_PERCENTAGE is undefined.');
  params.TV_THRESHOLD && console.error('TV_THRESHOLD is undefined.');
  params.HOLDER_ADDRESS && console.error('HOLDER_ADDRESS is undefined.');
};
