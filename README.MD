##1. TVToken

https://etherscan.io/address/0xf3e693175db47264c99eca0f1c1c4a2c1aed3bd7

Основной контракт токена  ERC20 (`TV`), токен используется как валюта во всех остальных контрактах проекта.

#### function safeTransferFrom ####
Перевод токенов с одного адреса на другой, адрес доставки может быть контрактом, если у него есть метод `function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4)` для приема токенов. 
```javascript
function safeTransferFrom(address _from, address _to, uint256 _value, bytes _data)
```

#### function revertFunds ####
Метод для возврата токенов вслучае ошибок. `Owner` контракта может перевести токены с любого адреса на любой.
```javascript
function revertFunds(address _from, address _to, uint256 _value) onlyOwner public returns (bool) 
```

##2. TVCrowdsale

https://etherscan.io/address/0xaae1be740222fb3f1125a7326fce947bbdb62b7e

Контракт `AllowanceCrowdsale` для продажи `TV` . При продаже токены берутся с адреса `_tokenWallet` эфир поступает на адрес `_wallet`.
В связи с этим владелец адреса `_tokenWallet` должен установить `allowance` для контракта. Если он закончится, купить токены будет невозможно.

#### function setRate ####
Устанавливает цену на `TV`. `_rate` это сколько полных `TV` (не `units`) покупатель получит за 1 эфир
```javascript
function setRate(uint256 _rate) public onlyOwnerOrManager returns (bool) 
```

##3. TVRefCrowdsale

https://etherscan.io/address/0x446fcf7b4bae4ae8d22bfb9d2b8c7e14f01aa211

Контракт для покупки `TV` через реферальную ссылку. Дополнительные токены беруться с адреса `holder`, поэтому необходим `allowance` для контракта. 

#### function buyTokens ####
Если у `refAddress` баланс `TV` больше `TVThreshold` или он добавлен в список исключений `exceptAddresses`,
при покупке токенов через этот метод дополнительный процент `refPercentage` идет на адрес `refAddress`.
 
```javascript
function buyTokens(address refAddress) public payable
```

##4. TVCoupon

https://etherscan.io/address/0x8f3061739ee46a2ad4e3a6967902c2e4c3aaf894

Контракт ERC721, имитирует бесплатный купон.

#### function getToken ####
Функция для получения купона. Получить купон можно только адреса на котором есть `TV`. Один купон на один адрес.
```javascript
function getToken() public 
```

##5. TVPremium

https://etherscan.io/address/0x659777fa17fabed00c66358436bf62a0c9563fb7

Контракт ERC721, имитирует премиум аккаунт. При покупки можно использовать купон и получить скидку.

#### function changeAndBuyPremium ####
Покупка за эфир.
```javascript
function changeAndBuyPremium(uint couponId) public payable
```

#### function onTokenReceived ####
В случае перевода `TV` на адрес контракта будет вызван этот метод. Тем самым будет совершена покупка за `TV`.
```javascript
 function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4)
```

##6. TVArtWork

https://etherscan.io/address/0x589da521a764e977005a4fbd7a0e1b9593c1c62d

Контракт ERC721, имитирует авторский контент.

#### function changeAndBuy ####
Покупка за эфир.
```javascript
function changeAndBuy(uint tokenId) public payable
```

#### function onTokenReceived ####
В случае перевода `TV` на адрес контракта будет вызван этот метод. Тем самым будет совершена покупка за `TV`.
```javascript
 function onTokenReceived(address _from, uint256 _value, bytes _data) public returns (bytes4)
```

##7. TVNewYearPack

https://etherscan.io/address/0xaf02e195e68e3967fecde7d484ddba19dec55677

Контракт ERC721 праздничных токенов и их раздачи. 

#### function getPack ####
Получить праздничные токены. Один набор на один адрес.
```javascript
 function getPack() public
```

##7. TVKey

https://etherscan.io/address/0x39643925006a9a0767eb2e10ce5df0ce1ee386ab

Контракт ERC721 (`TVK`), токен нужный для получения выигрыша в лотерее (`TVLottery`).  

##8. TVLottery

https://etherscan.io/address/0xac851fd3c969f24acb688abba158703279fe6856

Контракт лотереи.

* Сундук
По сути, приз в лотереи. Можно получить приз если у тебя есть соответствующий токен ключа
    ```
    struct Chest {
        uint id; 
        uint lotteryId;
        uint percentage; - процент от банка в этом сундуке
        uint count; - количество этих сундуков
        uint keysCount; - количество оставшихся ключей (TVK) от сундука
        uint openedCount; - количество открытых сундуков
        bool created;
    } 
    ```
    
* Коллекция
Набор токенов, который нужно собрать. Токен должен быть ERC721 и иметь тип.
    ```
    struct Collection {
        uint id;
        uint[] typeIds; - массив типов токенов в коллеции
        address[] tokens; - адреса контрактов токенов в коллекции
        uint chestId; - сундук, ключ (TVK) от которого получаешь, если собирешь коллекцию
        uint lotteryId;
        bool created;
    }
    ```
    
* Лоттерея
Набор токенов, который нужно собрать. Токен должен быть ERC721 и иметь тип.
    ```
    struct Lottery {
        uint id;
        address bank; - адрес с призовыми токенами (TV)
        uint[] collections; - коллекции, участвующие в данной лотереи
        uint bankPercentage; - остаток банка в процентах
        bool isActive;
        bool created;
    }
    ```

#### function setChest ####
Создание и редактирование сундука
```javascript
    function setChest(
        uint lotteryId,
        uint id,
        uint percentage,
        uint count,
        uint keysCount,
        uint openedCount,
        bool created
    ) public onlyOwnerOrManager
```

#### function setCollection ####
Создание и редактирование коллекции
```javascript
    function setCollection(
        uint id,
        uint[] typeIds,
        address[] tokens,
        uint chestId,
        uint lotteryId,
        bool created
    ) public onlyOwnerOrManager 
```

#### function setLottery ####
Создание и редактирование лотереи
```javascript
    function setLottery(
        uint id,
        address bank,
        uint[] _collections,
        uint bankPercentage,
        bool isActive,
        bool created
    ) public onlyOwnerOrManager
```

#### function onERC721Received ####
При передаче ключа `TVK` на адрес контракта будет вызван этот метод. На адрес с которого был послан ключ, будет переведен выигрыш в `TV`
```javascript
    function onERC721Received(
        address _from,
        uint256 _tokenId,
        bytes
    ) public returns (bytes4)
```

#### function getKey ####
Метод для получения ключа `TVK` за собранную коллекцию. ТОкены коллекции не забираются, но использование помечаются.
```javascript
    function getKey(uint lotteryId, uint collectionId, uint[] elementIds) public returns (uint)
```

