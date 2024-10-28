import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@typechain/hardhat"; // Ts TypeChain설정
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  defaultNetwork: "localhost",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545", // 로컬 노드 주소
      chainId: 31337, // 기본 Hardhat 네트워크 Chain ID
    },
    sepolia: {
      url: process.env.API_URL,
      chainId: parseInt(process.env.CHAIN_ID || ""),
      accounts: [process.env.PRIVATE_KEY || ""],
    },
  },
};

export default config;
