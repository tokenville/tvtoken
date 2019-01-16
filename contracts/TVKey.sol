pragma solidity ^0.4.0;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract TVKey is Ownable, ERC721Token {
    uint internal incrementId = 0;
    address public manager;
    address public lottery;

    struct Key {
        uint id;
        uint chestId;
    }

    mapping(uint => Key) public keys;

    modifier onlyOwnerOrManager() {
        require(msg.sender == owner || manager == msg.sender);
        _;
    }

    modifier onlyOwnerOrLottery() {
        require(msg.sender == owner || msg.sender == manager || msg.sender == lottery);
        _;
    }

    constructor(address _manager) public ERC721Token("TVKey Token", "TVKey") {
        manager = _manager;
    }

    function setTokenURI(uint256 _tokenId, string _uri) public onlyOwnerOrManager {
        super._setTokenURI(_tokenId, _uri);
    }

    function mint(address to, uint chestId) public onlyOwnerOrLottery returns(uint) {
        incrementId++;
        super._mint(to, incrementId);
        keys[incrementId] = Key(incrementId, chestId);
        return incrementId;
    }

    function burn(uint id) public onlyOwnerOf(id) {
        super._burn(msg.sender, id);
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }

    function setLottery(address _lottery) public onlyOwnerOrManager {
        lottery = _lottery;
    }
}
