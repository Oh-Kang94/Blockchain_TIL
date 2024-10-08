const { ethers } = require("hardhat");

async function main() {
    // 배포한 계약의 주소
    const fundraisingAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

    // 주소와 계약을 링크
    const fundraising = await ethers.getContractAt("FundRaising", fundraisingAddress);

    // Signers 가져오기
    const [fundraiser, addr1] = await ethers.getSigners(); // addr1 주소 가져오기

    // 기부 내역 조회
    const balance = await fundraising.balanceOf(fundraiser.address);

    console.log(`Address ${fundraiser.address} has donated ${balance.toString()} wei to ${fundraisingAddress}`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
