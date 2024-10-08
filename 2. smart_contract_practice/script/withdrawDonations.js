const { ethers } = require("hardhat");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

async function main() {
    // advance time by one hour and mine a new block
    await time.increase(3600 * 24 * 14 + 1);

    // 배포한 계약의 주소
    const fundraisingAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

    // 계약과 연결
    const fundraising = await ethers.getContractAt("FundRaising", fundraisingAddress);

    // Signers 가져오기 (소유자 주소)
    const [deployer] = await ethers.getSigners(); // 배포자 주소 가져오기

    // 인출 실행
    const tx = await fundraising.withdrawDonations();
    await tx.wait(); // 트랜잭션이 처리될 때까지 대기

    console.log(`Funds have been withdrawn by ${deployer.address}`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
