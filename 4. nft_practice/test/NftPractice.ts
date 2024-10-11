import { expect } from "chai";
import hre from "hardhat";
import { NftPractice } from "../typechain-types";

describe("NftPractice", function () {
  let nftContract: NftPractice;
  let owner: any;
  let addr1: any;
  let addr2: any;
  const tokenURI = "https://picsum.photos/id/237/200/300"; // LocalHost용 그냥 리얼 테스트용

  beforeEach(async function () {
    // 계약 배포
    const NftPractice = await hre.ethers.getContractFactory("NftPractice");
    // 유저 설정
    [owner, addr1, addr2] = await hre.ethers.getSigners();

    // 초기 소유자 설정
    nftContract = await NftPractice.deploy(owner.address);
  });

  describe("Minting", function () {
    it("should mint an NFT and assign it to the correct owner", async function () {
      var result = await nftContract.safeMint(addr1.address, tokenURI);

      // 민팅된 NFT의 소유자 확인
      expect(await nftContract.ownerOf(0)).to.equal(addr1.address);

      // 민팅된 NFT의 URI 확인
      expect(await nftContract.tokenURI(0)).to.equal(tokenURI);

      // Transaction 후, 이벤트 체크
      await expect(result)
        .to.emit(nftContract, "Minted") // 이벤트가 발생하는지 체크
        .withArgs(addr1.address, 0, tokenURI); // 이벤트 인자 확인 (0은 첫 번째 tokenId)
    });

    it("should only allow the owner to mint NFTs", async function () {
      // 다른 주소가 민팅 시도를 하면 에러 발생
      await expect(
        nftContract.connect(addr2).safeMint(addr2.address, "another-uri")
      ).to.be.reverted;
    });
  });
});
