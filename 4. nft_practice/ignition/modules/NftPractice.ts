// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const NftPracticeModule = buildModule("NftPracticeModule", (module) => {
  const lock = module.contract("NftPractice");

  return { lock };
});

export default NftPracticeModule;
