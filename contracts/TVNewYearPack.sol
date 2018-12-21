pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract TVNewYearPack is Ownable, ERC721Token {

    uint public typesCount;
    address public manager;
    uint internal incrementId = 0;

    struct Artefact {
        uint id;
        uint typeId;
    }

    mapping(address => bool) public received;

    modifier onlyOwnerOrManager() {
        require(msg.sender == owner || manager == msg.sender);
        _;
    }

    mapping(uint => Artefact) public artefacts;

    constructor(uint _typesCount, address _manager) public ERC721Token("TVNewYearPack Token", "TVNYPT") {
        manager = _manager;
        typesCount = _typesCount;
    }

    function mint(address to, uint typeId) public onlyOwnerOrManager {
        incrementId++;
        super._mint(to, incrementId);
        artefacts[incrementId] = Artefact(incrementId, typeId);
    }

    function burn(uint tokenId) public onlyOwnerOf(tokenId) {
        super._burn(msg.sender, tokenId);
        delete artefacts[tokenId];
    }

    function setTypesCount(uint _typesCount) public onlyOwnerOrManager {
        typesCount = _typesCount;
    }

    function getPack() public {
        require(!received[msg.sender]);
        uint count = typesCount;
        received[msg.sender] = true;
        for (uint i = 0; i < count; i++) {
            incrementId++;
            super._mint(msg.sender, incrementId);
            artefacts[incrementId] = Artefact(incrementId, i + 1);
        }
    }

    function getArtefactType(uint id) public view returns(uint) {
        return artefacts[id].typeId;
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }
}