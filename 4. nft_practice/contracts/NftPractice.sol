// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; // 이중 계약 방지

contract NftPractice is ERC721, ERC721URIStorage, Ownable {
    // 상태 변수
    uint256 private _nextTokenId; // 발행된 토큰의 수 저장

    // Event

    // NFT가 민팅 될때 발생
    event Minted(address indexed minter, uint256 nftID, string uri);

    // 여기서는 무조건 배포자가 소유자를 정해주고, 소유자만 가져갈수 있었지만, 그게 아니라 판매가 가능하기 때문에 구조를 바꾸어야한다.
    constructor(
        address initialOwner
    ) ERC721("My NFT", "NFT") Ownable(initialOwner) {}

    /// #1 Mint
    /// @param to : Minted Id
    /// @param uri : Image URI
    function safeMint(
        address to,
        string memory uri
    )
        public
        onlyOwner // Web3에서는 Public만 인식이 가능하다 //onlyOwner 소유자만 접근 가능
        returns (uint256)
    {
        uint256 tokenId = _nextTokenId++;

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        emit Minted(to, tokenId, uri);
        return tokenId;
    }

    //

    // 메타데이터의 URI에 반환
    // 여기서는 추가 구현은 안했다 cf) tokeID에 따른 다양한 uri 제공 가능
    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // 인터페이스 지원
    // 여기서는 추가 구현은 안했다.
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}


