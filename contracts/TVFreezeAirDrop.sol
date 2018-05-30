pragma solidity 0.4.21;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract TVToken {
    function transfer(address to, uint256 value) public returns (bool);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
}

contract TVFreezeAirDrop is Ownable {
    uint256 public unfreezeBlockNumber;
    TVToken public TVContract;
    address public holder;

    mapping(address => uint256) internal frozenTVs;

    event Withdraw(address to, uint256 amount, uint blockNumber);
    event SendTVs(address to, uint256 amount);
    event RevertTVs(address from, uint256 amount);

    function TVFreezeAirDrop(address _TVContract, address _holder, uint256 _unfreezeBlockNumber) public {
        unfreezeBlockNumber = _unfreezeBlockNumber;
        TVContract = TVToken(_TVContract);
        holder = _holder;
    }

    function revertFreezeTVs(address from) onlyOwner public {
        require(frozenTVs[from] > 0);

        uint256 amount = frozenTVs[from];
        frozenTVs[from] = 0;
        bool successful = TVContract.transfer(holder, amount);
        if (!successful) revert("Transfer from TVFreezeAirDrop to holder contract failed.");

        emit RevertTVs(from, frozenTVs[from]);
    }

    function sendFreezeTVs(address to, uint256 amount) onlyOwner public {
        bool successful = TVContract.transferFrom(holder, this, amount);
        if (!successful) revert("Transfer from holder to TVFreezeAirDrop contract failed.");
        frozenTVs[to] = amount;

        emit SendTVs(to, amount);
    }

    function withdrawTVs() public {
        require(block.number > unfreezeBlockNumber);

        uint256 amount = frozenTVs[msg.sender];
        frozenTVs[msg.sender] = 0;
        bool successful  = TVContract.transfer(msg.sender, amount);
        if (!successful) revert("Transfer from TVFreezeAirDrop to sender failed.");

        emit Withdraw(msg.sender, amount, block.number);
    }

    function freezeBalanceOf() public view returns(uint256) {
        return frozenTVs[msg.sender];
    }
}