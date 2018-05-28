'use strict';
const TVFreezeAirDrop = artifacts.require("./TVFreezeAirDrop.sol");
const TVToken = artifacts.require("./TVToken.sol");

const conf = {
  'ropsten': {
    UNFREEZE_BLOCK_NUMBER: 3326650,
    HOLDER_ADDRESS: '0x1feD8Ba9A9FDd72EF9038046ad148bEb413491b8'
  },
  'mainnet': {
    UNFREEZE_BLOCK_NUMBER: null,
    HOLDER_ADDRESS: ''
  }
};

module.exports = function(deployer, network, accounts) {
  let params = conf[network];
  let allParamsSet = params.UNFREEZE_BLOCK_NUMBER && params.HOLDER_ADDRESS;
  console.log(params);
  if (allParamsSet)  {
    return deployer.deploy(
      TVFreezeAirDrop,
      TVToken.address,
      params.HOLDER_ADDRESS,
      params.UNFREEZE_BLOCK_NUMBER,
    );
  }
  params.HOLDER_ADDRESS && console.error('HOLDER_ADDRESS is undefined.');
  params.UNFREEZE_BLOCK_NUMBER && console.error('UNFREEZE_BLOCK_NUMBER is undefined.');
};
