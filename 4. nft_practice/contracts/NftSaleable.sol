// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; // 이중 계약 방지

contract NftSaleable is ERC721URIStorage, ReentrancyGuard {
    // 상태 변수

    // 이전에는 그냥 올려서, 상관이 없지만, 외부에도 총 몇개가 발행되었는지 알려주기 위해 Public으로 선언
    uint256 public tokenCounter; // 발행된 토큰의 수 저장
    uint256 public listingCounter; // 지금까지의 경매의 횟수 저장

    // uint8 public constant STATUS_OPEN = 1;
    // uint8 public constant STATUS_DONE = 2;

    // 대안 ##1 하지만, 가스는 더 드나 미미하다.
    enum AuctionStatus {
        OPEN,
        DONE
    }

    uint256 public minAuctionIncrement = 5; // 5 percent

    // Modeling Auction Information
    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price; // display price => 현재 입찰가
        uint256 netPrice; // actual price => 판매자가 받을 실제 금액
        uint256 startAt;
        uint256 endAt;
        AuctionStatus status;
        // uint8 status;
    }

    // Event

    // NFT가 민팅 될때 발생
    event Minted(address indexed minter, uint256 nftID, string uri);

    // 새로운 거래가 일어날때 발생
    event AuctionCreated(
        uint256 listingId,
        address indexed seller,
        uint256 price,
        uint256 tokenId,
        uint256 startAt,
        uint256 endAt
    );

    // 새로운 입찰이 생길때 발생
    event BidCreated(uint256 listingId, address indexed bidder, uint256 bid);

    // 거래가 완료될때 발생
    event AuctionCompleted(
        uint256 listingId,
        address indexed seller,
        address indexed bidder,
        uint256 bid
    );

    // 입찰자가 입찰을 취소할때
    event WithdrawBid(uint256 listingId, address indexed bidder, uint256 bid);

    // Mapping

    mapping(uint256 => Listing) public listings; // 경매 목록을 관리 (경매 Id => 경매목록)
    mapping(uint256 => mapping(address => uint256)) public bids; // 입찰 목록 (입찰 id => (입찰자 지갑 주소 => 입찰 금액))
    mapping(uint256 => address) public highestBidder; // 최고 입찰자를 기록 (경매 id => 최고 입찰자 지갑 주소)

    // 이전에는 무조건 배포자가 소유자를 정해주고, 소유자만 가져갈수 있었지만, 그게 아니라 판매가 가능하기 때문에 구조를 바꾸어야한다.
    // 이름,symbol은 유일성에서 자유롭지만, 그냥 관행적으로 symbol은 식별자이기 때문에 특정 플랫폼이나 커뮤니티 내를 가리키는게 많음 3~6글자
    constructor() ERC721("ShinNFT", "SEUNG") {
        tokenCounter = 0;
        listingCounter = 0;
    }

    /// #1 Mint
    /// @param tokenURI tokenid
    /// @param minterAddress minterAddress
    function mint(
        string memory tokenURI,
        address minterAddress
    ) public returns (uint256) {
        tokenCounter++;
        uint256 tokenId = tokenCounter;

        _safeMint(minterAddress, tokenId);
        _setTokenURI(tokenId, tokenURI); // NFT 메타데이터에 대한 URI를 저장.

        emit Minted(minterAddress, tokenId, tokenURI);

        return tokenId;
    }

    /// #2 AuctionList
    /// @param price 초기 판매 가격
    /// @param tokenId tokenId
    /// @param durationInSeconds 경매 지속 시간
    function createAuctionListing(
        uint256 price,
        uint256 tokenId,
        uint256 durationInSeconds
    ) public returns (uint256) {
        listingCounter++;
        uint256 listingId = listingCounter;

        uint256 startAt = block.timestamp;
        uint256 endAt = startAt + durationInSeconds;

        // 구조체 만들어서 mapping에 연결
        listings[listingId] = Listing({
            seller: msg.sender,
            tokenId: tokenId,
            price: price,
            netPrice: price,
            status: AuctionStatus.OPEN,
            startAt: startAt,
            endAt: endAt
        });

        // 내부 함수 전송을 이용 실질적인 Transaction 진행
        _transfer(msg.sender, address(this), tokenId);

        emit AuctionCreated(
            listingId,
            msg.sender,
            price,
            tokenId,
            startAt,
            endAt
        );

        return listingId;
    }

    /// `payable`로 돈을 받을 수 있다.
    /// 실 입찰금액은 highestBidder에 value로 저장이되고,
    /// 그 후 입찰 시작 금액은 listing.price로 저장이 된다.
    /// @param listingId 경매 리스팅 id로 결제
    function bid(uint256 listingId) public payable nonReentrant {
        // nonReentrant는 한명이 입찰중이면 진입 할 수 없게 막음
        require(isAuctionOpen(listingId), "auction has ended");

        // storage는 영구저장 이고, 수정이 가능하며, 가스 비용이 상대적으로 더 높다.
        Listing storage listing = listings[listingId];

        require(msg.sender != listing.seller, "cannot bid on what you own");

        uint256 newBid = bids[listingId][msg.sender] + msg.value; // msg.value는 전송 금액

        // 새로운 비딩은 더 높아야한다.
        require(
            newBid > listing.price,
            "cannot bid below the latest bidding price"
        );

        // 이전 최종 입찰자 강제 환불
        _withdrawBid(listingId);

        bids[listingId][msg.sender] += msg.value;

        highestBidder[listingId] = msg.sender; // 최고 입찰자 기록

        // 물품 가액 * 1.01
        uint256 incentive = listing.price / minAuctionIncrement; // 최소 입찰 추가 금액
        listing.price = listing.price + incentive;

        emit BidCreated(listingId, msg.sender, newBid);
    }

    /// Solidity에는 Cron의 기능이 없다. 외부 서비스에 의존이 필요
    /// address(this)는 스마트 계약이 NFT를 소유하고 있고, 그 NFT를 가져가서 결과에 따라 준다.
    /// @param listingId : 리스트 아이디
    function completeAuction(uint256 listingId) public payable nonReentrant {
        require(!isAuctionOpen(listingId), "auction is still open");

        Listing storage listing = listings[listingId];

        address winner = highestBidder[listingId];

        require(
            msg.sender == listing.seller || msg.sender == winner,
            "only seller or winner can complete auction"
        );

        if (winner != address(0)) {
            // 최종입찰자에게 NFT 증정
            _transfer(address(this), winner, listing.tokenId);

            uint256 amount = bids[listingId][winner];

            bids[listingId][winner] = 0;
            // 판매자에게 금액 전송
            _transferFund(payable(listing.seller), amount);
        } else {
            // 유찰시, Seller에게 주는것. 해당 NFT의 고유식별자(listing.tokenId)를 통해서 소유권을 전송
            _transfer(address(this), listing.seller, listing.tokenId);
        }

        listing.status = AuctionStatus.DONE;

        emit AuctionCompleted(
            listingId,
            listing.seller,
            winner,
            bids[listingId][winner]
        );
    }

    // function withdrawBid(uint256 listingId) public payable nonReentrant {
    //     require(isAuctionExpired(listingId), "auction must be ended");
    //     // 최고 입찰자는 철회 불가
    //     require(
    //         highestBidder[listingId] != msg.sender,
    //         "highest bidder cannot withdraw bid"
    //     );

    //     uint256 balance = bids[listingId][msg.sender];
    //     bids[listingId][msg.sender] = 0;
    //     _transferFund(payable(msg.sender), balance);

    //     emit WithdrawBid(listingId, msg.sender, balance);
    // }

    // 이전 최종 입찰자 환불
    function _withdrawBid(uint256 listingId) internal {
        address lastBidder = highestBidder[listingId];
        uint256 balance = bids[listingId][lastBidder];

        // 이전 입찰자의 잔액을 0으로 설정
        bids[listingId][lastBidder] = 0;

        // 환불 처리
        _transferFund(payable(lastBidder), balance);

        // 이벤트 발생
        emit WithdrawBid(listingId, lastBidder, balance);
    }

    // No Transaction Function (No Gas)

    /// 경매가 열려있는지?
    /// @param id 경매 ID
    /// @return bool 경매가 열려있는지 확인
    function isAuctionOpen(uint256 id) public view returns (bool) {
        // `view`는 상태변경은 불가, 외부에서 호출 가능
        return
            listings[id].status == AuctionStatus.OPEN &&
            listings[id].endAt > block.timestamp;
    }

    /// 경매가 만료되어 있는지?
    /// @param id 경매 ID
    /// @return bool 경매가 만료되었는지 확인
    function isAuctionExpired(uint256 id) public view returns (bool) {
        return listings[id].endAt <= block.timestamp;
    }

    // Private Function

    /// 송금
    /// `internal` 내부에서만 실행 가능함수
    /// @param to 송금 받을 사람
    /// @param amount 가격
    /// return nothing
    function _transferFund(address payable to, uint256 amount) internal {
        if (amount == 0) {
            return;
        }
        require(to != address(0), "Error, cannot transfer to address(0)");

        (bool transferSent, ) = to.call{value: amount}("");
        // to: 이더를 전송받을 주소를 나타냅니다.
        // value: amount: 전송할 이더의 양을 의미합니다. 여기서 amount는 전송할 ETH의 양을 지정합니다.
        // "": 여기에 데이터를 전달할 수 있지만, 빈 데이터를 전달하는 경우입니다. 즉, 데이터를 보내지 않고 단순히 이더만 전송하는 것입니다.

        require(transferSent, "Error, failed to send Ether");
    }
}

// Reference : https://gist.githubusercontent.com/verdotte/f15351646e5cfdd59a553af2fa188a8d/raw/14436a800a722bc4aed7c9051f9b33dff865d28c/auction.sol

//  (bool transferSent, ) = to.call{value: amount}("");
// 은 반환하고자 싶은 값이 있을때 에는
//(bool success, bytes memory data) = to.call(abi.encodeWithSignature("myFunction()"));
// require(success, "Call failed");
// string memory result = abi.decode(data, (string));
// 이런식으로 쓰인다.
