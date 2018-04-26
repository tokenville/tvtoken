pragma solidity ^0.4.21;

import 'zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract TVToken is PausableToken, MintableToken {
  string public name = 'TV Token';
  string public symbol = 'TVT';
  uint8 public decimals = 18;

  function TVToken() public {}

  function revertFunds(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(_from, _to, _value);
    return true;
  }
}
