pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract ITVToken {
    function balanceOf(address _to) public returns (uint);
}

contract TVCoupon is Ownable, ERC721Token {
    uint internal incrementId = 0;
    address public TVTokenAddress;

    mapping(address => bool) public received;

    constructor(address _TVTokenAddress) public ERC721Token("TVCoupon Token", "TVC") {
        TVTokenAddress = _TVTokenAddress;
    }

    function getToken() public {
        require(!received[msg.sender]);
        require(ITVToken(TVTokenAddress).balanceOf(msg.sender) > 0);
        received[msg.sender] = true;
        super._mint(msg.sender, incrementId);
    }
}