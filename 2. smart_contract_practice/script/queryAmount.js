const { ethers } = require("hardhat");

async function main() {
    // 배포한 계약의 주소
    const fundraisingAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

    // 주소와 계약을 링크
    const fundraising = await ethers.getContractAt("FundRaising", fundraisingAddress);

    // 전체 모금액 확인
    const totalRaised = await fundraising.raisedAmount();

    console.log(`Total amount raised is ${ethers.formatEther(totalRaised)} ETH`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
