const { getNamedAccounts, ethers, deployments } = require("hardhat");

async function main() {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const FundMe = await ethers.getContract("FundMe", deployer);
  console.log("funding......");
  const transactionResponse = await FundMe.withdraw();
  console.log("Got my money back!!!!");
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.log(e);
    process.exit(1);
  });
