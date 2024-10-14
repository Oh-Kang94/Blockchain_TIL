// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const NftSaleableModule = buildModule("NftSaleableModule", (module) => {
  const nftSaleable = module.contract("NftSaleable");

  return { nftSaleable };
});

export default NftSaleableModule;