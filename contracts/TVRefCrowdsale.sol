pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract TVCrowdsale {
    uint256 public currentRate;
    function buyTokens(address _beneficiary) public payable;
}

contract TVToken {
    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function balanceOf(address _owner) public view returns (uint256);
}

contract TVRefCrowdsale is Ownable {
    TVToken public TVContract;
    TVCrowdsale public TVCrowdsaleContract;
    uint256 public refPercentage;
    uint256 public TVThreshold;
    address public holder;

    event TransferRefTVs(address holder, address sender, uint256 amount, uint256 TVThreshold, uint256 balance);
    event BuyTokens(address sender, uint256 amount);

    constructor(
        address _TVTokenContract,
        address _TVCrowdsaleContract,
        uint256 _refPercentage,
        uint256 _TVThreshold,
        address _holder
    ) public {
        TVContract = TVToken(_TVTokenContract);
        TVCrowdsaleContract = TVCrowdsale(_TVCrowdsaleContract);
        refPercentage = _refPercentage;
        TVThreshold = _TVThreshold;
        holder = _holder;
    }

    function buyTokens(address refAddress) public payable {
        TVCrowdsaleContract.buyTokens.value(msg.value)(msg.sender);
        emit BuyTokens(msg.sender, msg.value);
        sendRefTVs(refAddress);
    }

    function sendRefTVs(address refAddress) internal returns(bool) {
        uint256 balance = TVContract.balanceOf(refAddress);
        if (balance >= TVThreshold) {
            uint256 amount = (msg.value * TVCrowdsaleContract.currentRate()) * refPercentage / 100;
            bool successful = TVContract.transferFrom(holder, msg.sender, amount);
            if (!successful) revert("Transfer refTVs failed.");
            emit TransferRefTVs(holder, msg.sender, amount, TVThreshold, balance);
            return true;
        }
        return true;
    }

    function changeRefPercentage(uint256 percentage) onlyOwner public {
        require(percentage > 0);
        refPercentage = percentage;
    }

    function changeThreshold(uint256 threshold) onlyOwner public {
        require(threshold > 0);
        TVThreshold = threshold;
    }
}