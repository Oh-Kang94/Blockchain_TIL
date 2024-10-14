import { ethers } from "hardhat";
import { NftPractice } from "../../typechain-types";

async function main() {
  // Signers 가져오기
  const nftPracticeAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

  const nftPractice: NftPractice = await ethers.getContractAt(
    "NftPractice",
    nftPracticeAddress
  );

  const tokenURI = await nftPractice.tokenURI(0);

  console.log(`Token URI : ${tokenURI}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
