pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract TVCoupon is Ownable, ERC721Token {
    uint internal incrementId = 0;

    mapping(address => bool) public received;

    constructor() public ERC721Token("TVCoupon Token", "TVC") {}

    function getToken() public {
        require(!received[msg.sender]);
        received[msg.sender] = true;
        super._mint(msg.sender, incrementId);
    }
}