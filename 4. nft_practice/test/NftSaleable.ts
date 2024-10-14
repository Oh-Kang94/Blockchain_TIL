import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract } from "ethers";
import { NftSaleable } from "../typechain-types";

describe("NftSaleable", function () {
  let nftSaleable: NftSaleable;
  let owner: any;
  let addr1: any;
  let addr2: any;
  let addrs: any[];

  const TOKEN_URI = "https://example.com/token/";
  const AUCTION_DURATION = 60 * 60 * 24; // 1 day
  const INITIAL_PRICE = ethers.parseEther("1"); // 1 ETH

  beforeEach(async function () {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    const NftSaleableFactory = await ethers.getContractFactory("NftSaleable");
    nftSaleable = await NftSaleableFactory.deploy();
  });

  describe("Deployment", function () {
    it("Should set the right name and symbol", async function () {
      expect(await nftSaleable.name()).to.equal("ShinNFT");
      expect(await nftSaleable.symbol()).to.equal("SEUNG");
    });

    it("Should initialize counters to zero", async function () {
      expect(await nftSaleable.tokenCounter()).to.equal(0);
      expect(await nftSaleable.listingCounter()).to.equal(0);
    });
  });

  describe("Minting", function () {
    it("Should mint a new token and emit Minted event", async function () {
      const firstTokenId: number = 1;
      const secondTokenId: number = 2;

      // Event 를 잘 뱉어내는지 확인
      await expect(nftSaleable.mint(TOKEN_URI, addr1.address))
        .to.emit(nftSaleable, "Minted")
        .withArgs(addr1.address, firstTokenId, TOKEN_URI);

      expect(await nftSaleable.tokenCounter()).to.equal(firstTokenId);
      expect(await nftSaleable.ownerOf(firstTokenId)).to.equal(addr1.address);
      expect(await nftSaleable.tokenURI(firstTokenId)).to.equal(TOKEN_URI);

      // 2번째 결과도 예상한대로 가는지 확인
      await expect(nftSaleable.mint(TOKEN_URI, addr2.address))
        .to.emit(nftSaleable, "Minted")
        .withArgs(addr2.address, secondTokenId, TOKEN_URI);

      expect(await nftSaleable.tokenCounter()).to.equal(secondTokenId);
      expect(await nftSaleable.ownerOf(secondTokenId)).to.equal(addr2.address);
      expect(await nftSaleable.tokenURI(secondTokenId)).to.equal(TOKEN_URI);
    });
  });

  describe("Auction Listing", function () {
    beforeEach(async function () {
      await nftSaleable.mint(TOKEN_URI, addr1.address);
      await nftSaleable
        .connect(addr1)
        .approve(await nftSaleable.getAddress(), 1);
    });

    it("Should create an auction listing and emit AuctionCreated event", async function () {
      // # 1 : Transaction을 일으키고,
      const tx = await nftSaleable
        .connect(addr1)
        .createAuctionListing(INITIAL_PRICE, 1, AUCTION_DURATION);
      const receipt = await tx.wait();

      // #2 Block을 가지고, 정확한 timeStamp와 AuctionDuration을 가져온다.
      const block = await ethers.provider.getBlock(receipt!.blockHash);
      const startTime = block!.timestamp; // Now we use the actual block timestamp
      const endTime = startTime + AUCTION_DURATION;

      await expect(tx)
        .to.emit(nftSaleable, "AuctionCreated")
        .withArgs(1, addr1.address, INITIAL_PRICE, 1, startTime, endTime);

      expect(await nftSaleable.listingCounter()).to.equal(1);
      const listing = await nftSaleable.listings(1);
      expect(listing.seller).to.equal(addr1.address);
      expect(listing.tokenId).to.equal(1);
      expect(listing.price).to.equal(INITIAL_PRICE);
      expect(listing.status).to.equal(0); // AuctionStatus.OPEN
    });
  });

  describe("Bidding", function () {
    beforeEach(async function () {
      await nftSaleable.mint(TOKEN_URI, addr1.address);
      await nftSaleable
        .connect(addr1)
        .approve(await nftSaleable.getAddress(), 1);
      await nftSaleable
        .connect(addr1)
        .createAuctionListing(INITIAL_PRICE, 1, AUCTION_DURATION);
    });

    it("Should place a bid and emit BidCreated event", async function () {
      const bidAmount = INITIAL_PRICE + ethers.parseEther("0.1");
      await expect(nftSaleable.connect(addr2).bid(1, { value: bidAmount }))
        .to.emit(nftSaleable, "BidCreated")
        .withArgs(1, addr2.address, bidAmount);

      expect(await nftSaleable.highestBidder(1)).to.equal(addr2.address);
      const listing = await nftSaleable.listings(1);
      expect(listing.price).to.be.gt(INITIAL_PRICE);
    });

    it("Should not allow bids below the current price", async function () {
      await expect(
        nftSaleable.connect(addr2).bid(1, { value: INITIAL_PRICE })
      ).to.be.revertedWith("cannot bid below the latest bidding price");
    });

    it("Should not allow the seller to bid", async function () {
      await expect(
        nftSaleable.connect(addr1).bid(1, { value: INITIAL_PRICE * BigInt(2) })
      ).to.be.revertedWith("cannot bid on what you own");
    });
  });

  describe("Completing Auction", function () {
    beforeEach(async function () {
      await nftSaleable.mint(TOKEN_URI, addr1.address);
      await nftSaleable
        .connect(addr1)
        .approve(await nftSaleable.getAddress(), 1);
      await nftSaleable
        .connect(addr1)
        .createAuctionListing(INITIAL_PRICE, 1, AUCTION_DURATION);
      await nftSaleable
        .connect(addr2)
        .bid(1, { value: INITIAL_PRICE + ethers.parseEther("0.15") });
    });

    it("Should complete the auction and transfer NFT to the winner", async function () {
      await ethers.provider.send("evm_increaseTime", [AUCTION_DURATION + 1]);
      await ethers.provider.send("evm_mine");

      await expect(nftSaleable.connect(addr1).completeAuction(1))
        .to.emit(nftSaleable, "AuctionCompleted")
        .withArgs(
          1,
          addr1.address,
          addr2.address,
          INITIAL_PRICE + ethers.parseEther("0.15")
        );

      expect(await nftSaleable.ownerOf(1)).to.equal(addr2.address);
      const listing = await nftSaleable.listings(1);
      expect(listing.status).to.equal(1); // AuctionStatus.DONE
    });

    it("Should not allow completing an auction before it ends", async function () {
      await expect(
        nftSaleable.connect(addr1).completeAuction(1)
      ).to.be.revertedWith("auction is still open");
    });
  });

  describe("Utility Functions", function () {
    beforeEach(async function () {
      await nftSaleable.mint(TOKEN_URI, addr1.address);
      await nftSaleable
        .connect(addr1)
        .approve(await nftSaleable.getAddress(), 1);
      await nftSaleable
        .connect(addr1)
        .createAuctionListing(INITIAL_PRICE, 1, AUCTION_DURATION);
    });

    it("Should correctly report if an auction is open", async function () {
      expect(await nftSaleable.isAuctionOpen(1)).to.be.true;

      await ethers.provider.send("evm_increaseTime", [AUCTION_DURATION + 1]);
      await ethers.provider.send("evm_mine", []);

      expect(await nftSaleable.isAuctionOpen(1)).to.be.false;
    });

    it("Should correctly report if an auction is expired", async function () {
      expect(await nftSaleable.isAuctionExpired(1)).to.be.false;

      await ethers.provider.send("evm_increaseTime", [AUCTION_DURATION + 1]);
      await ethers.provider.send("evm_mine", []);

      expect(await nftSaleable.isAuctionExpired(1)).to.be.true;
    });
  });
});
