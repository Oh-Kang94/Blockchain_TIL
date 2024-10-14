import { NftSaleable } from "../../typechain-types";
import { ethers } from "hardhat";

async function main() {
  // 배포한 계약의 주소
  const nftSaleableAddress = "0xa513E6E4b8f2a923D98304ec87F64353C4D5C853";
  // Signers 가져오기
  const [_, addr1, addr2] = await ethers.getSigners();

  const nftSaleable: NftSaleable = await ethers.getContractAt(
    "NftSaleable",
    nftSaleableAddress
  );

  const tokenURI = "https://picsum.photos/id/237/200/300"; // LocalHost용 그냥 리얼 테스트용
  await nftSaleable.mint(tokenURI, addr1.address);

  const events = await nftSaleable.queryFilter(nftSaleable.filters.Minted, -1);

  console.log(
    `Minted event emitted: Minter - ${events[0].args[0]}, TokenId - ${events[0].args[1]}, URI - ${events[0].args[2]}`
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
