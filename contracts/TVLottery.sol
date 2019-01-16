pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol";

contract ITVToken {
    function balanceOf(address _owner) public view returns (uint256);

    function transfer(address _to, uint256 _value) public returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
    function safeTransfer(address _to, uint256 _value, bytes _data) public;
}

contract IArtefact {
    function artefacts(uint id) public returns (uint, uint);

    function ownerOf(uint256 _tokenId) public view returns (address);
}

contract ITVKey {
    function transferFrom(address _from, address _to, uint256 _tokenId) public;

    function keys(uint id) public returns (uint, uint);

    function mint(address to, uint chestId, uint lotteryId) public returns (uint);

    function burn(uint id) public;
}

contract TVLottery is Ownable, ERC721Receiver {
    address public manager;
    address public TVTokenAddress;
    address public TVKeyAddress;

    struct Collection {
        uint id;
        uint[] typeIds;
        address[] tokens;
        uint chestTypeId;
        bool created;
    }

    struct Lottery {
        uint id;
        address bank;
        uint[] collections;
        uint[] chests;
        uint bankPercentage;
        bool isActive;
        bool created;
    }

    struct Chest {
        uint id;
        uint lotteryId;
        uint percentage;
        uint count;
        uint keysCount;
        bool created;
    }

    mapping(uint => Lottery) public lotteries;
    mapping(uint => Chest) public chests;
    mapping(uint => Collection) public collections;
    mapping(uint => mapping(address => bool)) public usedElements;

    event KeyReceived(uint keyId, uint lotteryId, uint collectionId, uint chestId, address receiver);
    event ChestOpened(uint keyId, uint lotteryId, uint chestId, uint reward, address receiver);

    modifier onlyOwnerOrManager() {
        require(msg.sender == owner || manager == msg.sender);
        _;
    }

    constructor(
        address _TVTokenAddress,
        address _TVKeyAddress,
        address _manager
    ) public {
        manager = _manager;
        TVTokenAddress = _TVTokenAddress;
        TVKeyAddress = _TVKeyAddress;
    }

    function onERC721Received(
        address _from,
        uint256 _tokenId,
        bytes
    ) public returns (bytes4) {
        (, uint chestId) = ITVKey(TVKeyAddress).keys(_tokenId);
        Chest memory chest = chests[chestId];
        Lottery memory lottery = lotteries[chest.lotteryId];

        ITVKey(TVKeyAddress).transferFrom(this, lottery.bank, _tokenId);
        lottery.bankPercentage -= chest.percentage;
        uint reward = getChestReward(chestId);
        ITVToken(TVTokenAddress).transferFrom(lottery.bank, _from, reward);
        emit ChestOpened(_tokenId, lottery.id, chest.id, reward, _from);
        return ERC721_RECEIVED;
    }

    function getChestReward(uint chestId) public view returns (uint) {
        Chest memory chest = chests[chestId];
        Lottery memory lottery = lotteries[chest.lotteryId];
        uint bankBalance = ITVToken(TVTokenAddress).balanceOf(lottery.bank);
        uint onePercentage = bankBalance / lottery.bankPercentage * 100;
        return chest.percentage * onePercentage;
    }

    function getKey(uint lotteryId, uint collectionId, uint[] elementIds) public returns (uint) {
        Lottery memory lottery = lotteries[lotteryId];
        Collection memory collection = collections[collectionId];
        (bool found, uint collectionIndex) = findCollectionIndex(collectionId, lottery);
        require(found);
        Chest memory chest = chests[collectionIndex];

        require(lottery.created && lottery.isActive && collection.created);
        require(chest.keysCount > 0);

        checkCollection(collection, elementIds);

        chest.keysCount--;
        uint keyId = ITVKey(TVKeyAddress).mint(msg.sender, chest.id, lotteryId);
        emit KeyReceived(keyId, lotteryId, collectionId, chest.id, msg.sender);

        return keyId;
    }

    function findCollectionIndex(uint collectionId, Lottery lottery) internal pure returns (bool, uint) {
        for (uint i = 0; i < lottery.collections.length; i++) {
            if (lottery.collections[i] == collectionId) {
                return (true, i);
            }
        }
        return (false, 0);
    }

    function checkCollection(Collection collection, uint[] elementsIds) internal {
        require(elementsIds.length == collection.typeIds.length);
        for (uint i = 0; i < elementsIds.length; i++) {
            (uint id, uint typeId) = IArtefact(collection.tokens[i]).artefacts(elementsIds[i]);
            require(typeId == collection.typeIds[i]);
            require(!usedElements[id][collection.tokens[i]]);
            require(IArtefact(collection.tokens[i]).ownerOf(id) == msg.sender);
            usedElements[id][collection.tokens[i]] = true;
        }
    }

    function setCollection(
        uint id,
        uint[] typeIds,
        address[] tokens,
        uint chestTypeId,
        bool created
    ) public onlyOwnerOrManager {
        require(typeIds.length == tokens.length);
        collections[id] = Collection(id, typeIds, tokens, chestTypeId, created);
    }

    function setChest(
        uint lotteryId,
        uint id,
        uint percentage,
        uint count,
        uint keysCount,
        bool created
    ) public onlyOwnerOrManager {
        chests[id] = Chest(id, lotteryId, percentage, count, keysCount, created);
    }

    function setLottery(
        uint id,
        address bank,
        uint[] _collections,
        uint[] _chests,
        uint bankPercentage,
        bool isActive,
        bool created
    ) public onlyOwnerOrManager {
        lotteries[id] = Lottery(id, bank, _collections, _chests, bankPercentage, isActive, created);
    }

    function changeLotteryBank(uint lotteryId, address bank, uint bankPercentage) public onlyOwnerOrManager {
        lotteries[lotteryId].bank = bank;
        lotteries[lotteryId].bankPercentage = bankPercentage;
    }

    function updateCollections(uint lotteryId, uint[] _collections, uint[] _chests) public onlyOwnerOrManager {
        require(_chests.length == _collections.length);
        lotteries[lotteryId].collections = _collections;
        lotteries[lotteryId].chests = _chests;
    }

    function setLotteryActive(uint id, bool isActive) public onlyOwnerOrManager {
        lotteries[id].isActive = isActive;
    }

    function changeTVTokenAddress(address newAddress) public onlyOwnerOrManager {
        TVTokenAddress = newAddress;
    }

    function changeTVKeyAddress(address newAddress) public onlyOwnerOrManager {
        TVKeyAddress = newAddress;
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }
}