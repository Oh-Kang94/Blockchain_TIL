require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers"); // For Test
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.0",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",  // 로컬 노드 주소
      chainId: 31337,  // 기본 Hardhat 네트워크 Chain ID
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
};
// 계좌 목록을 출력하는 태스크
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  const provider = hre.ethers.provider;

  for (const account of accounts) {
    const balance = await provider.getBalance(account.address);
    console.log(
      "%s (%s ETH)",
      account.address,
      hre.ethers.formatEther(balance)  // 잔액을 ETH로 포맷팅
    );
  }
});