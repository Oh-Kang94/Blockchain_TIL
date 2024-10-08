const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const FundRaisingModule = buildModule("FundRaisingModule", (module) => {
    // _targetAmount를 제공 (예: 1 ETH)
    const targetAmount = ethers.parseEther("1");
    // Token 컨트랙트를 Ignition을 통해 배포
    const fundRaising = module.contract("FundRaising", [targetAmount]);

    // 배포된 컨트랙트 반환
    return { fundRaising };
});

module.exports = FundRaisingModule;
