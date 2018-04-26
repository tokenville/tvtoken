pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';

contract TVCrowdsale is AllowanceCrowdsale, Ownable {
  uint256 public currentRate;
  
  function TVCrowdsale(uint256 _rate, address _wallet, ERC20 _token, address _tokenWallet)
    Crowdsale(_rate, _wallet, _token)
    AllowanceCrowdsale(_tokenWallet) public {
    currentRate = _rate;
  }
  
  function setRate(uint256 _rate) public onlyOwner returns (bool) {
    currentRate = _rate;
    return true;
  }
  
  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
    return _weiAmount.mul(currentRate);
  }

}
