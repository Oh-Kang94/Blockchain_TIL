# NFT PRACTICE

### Mint vs SafeMint

- 1. mint
     기본 기능: mint 메서드는 주어진 주소에 지정된 ID의 토큰을 생성합니다.
     안전성 부족: mint는 수신자가 ERC721 토큰을 안전하게 처리할 수 있는지 여부를 확인하지 않습니다. 즉, 만약 토큰을 발행한 주소가 ERC721 수신자 인터페이스(IERC721Receiver)를 구현하지 않거나, 올바르게 구현하지 않은 경우, 해당 토큰은 수신자 주소에 성공적으로 전송되지 않더라도 계약의 상태가 변경되어 버그나 오류를 유발할 수 있습니다.

- 2. safeMint
     안전한 발행: safeMint 메서드는 mint와 유사하지만, 수신자가 ERC721 토큰을 받을 수 있는지 확인하는 추가적인 안전성 검사를 수행합니다.
     IERC721Receiver 인터페이스 체크: safeMint는 토큰이 발행된 후, 수신자가 IERC721Receiver 인터페이스를 구현하고 있는지를 확인합니다. 만약 수신자가 이 인터페이스를 구현하지 않으면, 토큰 발행이 실패하고 트랜잭션이 revert됩니다. 이를 통해 예기치 않은 동작이나 데이터 손실을 방지할 수 있습니다.

### 변경점

원래는 openZeppelin 5.0 이하 버젼에서는

openzeppelin/contracts/utils/Counters.sol 이라는 라이브러리를 의존하게 되었는데,
그 이상 버젼에서는 라이브러리를 의존하지 않는다

- before 5.0

```

pragma solidity < ^0.8.0;

contract GameItem is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
     constructor() ERC721("GameItem", "ITM") {}

     function awardItem(address player, string memory tokenURI)
         public
         returns (uint256)
     {
         uint256 newItemId = _tokenIds.current();
         _mint(player, newItemId);
         _setTokenURI(newItemId, tokenURI);

         _tokenIds.increment();
         return newItemId;
     }
}


```

- after 5.0

```
contract GameItem is ERC721URIStorage {
    //using Counters for Counters.Counter;
    //Counters.Counter private tokenIds;
    uint256 private tokenIds;
    constructor() ERC721("GameItem", "ITM") {}

    function awardItem(address player, string memory tokenURI)
        public
        returns (uint256)
    {
        //uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        //_tokenIds.increment();
        _tokenIds++; //Regular uint management
        return newItemId;
    }
}
```
