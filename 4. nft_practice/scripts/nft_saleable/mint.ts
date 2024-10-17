import { NftSaleable } from "../../typechain-types";
import { ethers } from "hardhat";

async function main() {
  // 배포한 계약의 주소
  const nftSaleableAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
  // Signers 가져오기
  const [_, addr1, addr2] = await ethers.getSigners();

  const nftSaleable: NftSaleable = await ethers.getContractAt(
    "NftSaleable",
    nftSaleableAddress
  );

  const randomNumber: number = _randomInteger(100, 150);

  const tokenURI: string = `https://picsum.photos/id/${randomNumber}/200/300`; // LocalHost용 그냥 리얼 테스트용
  const mintTx = await nftSaleable.mint(tokenURI, addr1.address);

  const events = await nftSaleable.queryFilter(
    nftSaleable.filters.Minted(),
    -1
  );

  console.log(
    `Minted event emitted: Minter - ${events[0].args[0]}, TokenId - ${events[0].args[1]}, URI - ${events[0].args[2]}`
  );

  function _randomInteger(min: number, max: number) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
