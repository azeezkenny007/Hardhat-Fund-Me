const { network } = require("hardhat");
const {
  developmentChains,
  DECIMALS,
  INITIAL_AWNSER,
} = require("../helper-hardhat.config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  let chainId = network.config.chainId;

  if ((chainId = 31337)) {
    log("local network detected! Deploying mocks....");
    await deploy("MockV3Aggregator", {
      contract: "MockV3Aggregator",
      from: deployer,
      log: true,
      args: [DECIMALS, INITIAL_AWNSER],
    });

    log("logs deployed");
    log("-----------------------------------");
  }
};

module.exports.tags = ["all", "mocks"];
