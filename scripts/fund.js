const { getNamedAccounts, ethers, deployments } = require("hardhat");

async function main() {
  const { deployer } = await getNamedAccounts();
  const FundMe = await ethers.getContract("FundMe", deployer);
  console.log("funding contract.......");
  const transactionResponse = await FundMe.fund({
    value: ethers.utils.parseEther("0.01"),
  });
  await transactionResponse.wait(1);
  console.log("contract has been funded!!!!! hurray!!");
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.log(e);
    process.exit(1);
  });
