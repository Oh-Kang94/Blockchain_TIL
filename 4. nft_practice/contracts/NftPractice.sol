// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NftPractice is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    constructor(
        address initialOwner
    ) ERC721("My NFT", "NFT") Ownable(initialOwner) {}

    function safeMint(
        address to,
        string memory uri
    )
        public
        onlyOwner // Web3에서는 Public만 인식이 가능하다 //onlyOwner 소유자만 접근 가능
    {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

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
