const hre = require("hardhat");

async function main() {
  const Proxy = await hre.ethers.getContractFactory("Proxy");
  const proxy = await Proxy.deploy();

  await proxy.deployed();

  console.log("Proxy deployed to:", proxy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
