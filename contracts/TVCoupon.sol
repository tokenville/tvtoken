pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract TVCoupon is Ownable, ERC721Token {
    uint internal incrementId = 0;

    constructor() public ERC721Token("TVCoupon Token", "TVC") {}

    function getToken() public {
        require(super.balanceOf(msg.sender) == 0);
        super._mint(msg.sender, incrementId);
    }
}