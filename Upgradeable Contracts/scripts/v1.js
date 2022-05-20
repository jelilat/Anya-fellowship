const hre = require("hardhat");

async function main() {
  const Shoppingv1 = await hre.ethers.getContractFactory("Shoppingv1");
  const shoppingv1 = await Shoppingv1.deploy();

  await shoppingv1.deployed();

  console.log("Shoppingv1 deployed to:", shoppingv1.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
