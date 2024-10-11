import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@typechain/hardhat"; // Ts TypeChain설정

const config: HardhatUserConfig = {
  solidity: "0.8.20",
};

export default config;
