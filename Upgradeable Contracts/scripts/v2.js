const hre = require("hardhat");

async function main() {
  const Shoppingv2 = await hre.ethers.getContractFactory("Shoppingv2");
  const shoppingv2 = await Shoppingv2.deploy();

  await shoppingv2.deployed();

  console.log("Shoppingv2 deployed to:", shoppingv2.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
