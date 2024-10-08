const { ethers } = require("hardhat");

async function main() {
    // 배포한 계약의 주소 (여기에서 주소를 실제 배포된 계약 주소로 변경하세요)
    const fundraisingAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    // 주소와 계약을 링크
    const fundraising = await ethers.getContractAt("FundRaising", fundraisingAddress);

    // Signers 가져오기
    const [deployer, addr1, ...addr3] = await ethers.getSigners(); // 배포자 주소 가져오기

    const donationAmount = ethers.parseEther("1"); // 기부할 금액 설정 (예: 0.1 ETH)

    // 기부 실행
    // const tx = await deployer.sendTransaction({
    //     to: fundraisingAddress,
    //     value: donationAmount,
    // });
    const tx = await addr1.sendTransaction({
        to: fundraising.target,
        value: donationAmount,
    });

    await tx.wait(); // 트랜잭션이 처리될 때까지 대기

    console.log(`deployer ${addr1.address}: Donated ${donationAmount.toString()} wei to ${fundraisingAddress}`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


