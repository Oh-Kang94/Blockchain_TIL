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
