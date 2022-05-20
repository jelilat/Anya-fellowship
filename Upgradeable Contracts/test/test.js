require("@nomiclabs/hardhat-waffle");
const { expect } = require("chai");

describe("Proxy", async () => {
  let owner;
  let proxy, shoppingv1;

  beforeEach(async () => {
    [owner] = await ethers.getSigners();

    const Shoppingv1 = await ethers.getContractFactory("Shoppingv1");
    shoppingv1 = await Shoppingv1.deploy();
    await shoppingv1.deployed();

    const Proxy = await ethers.getContractFactory("Proxy");
    proxy = await Proxy.deploy();
    await proxy.deployed();

    await proxy.setImplementation(shoppingv1.address);

    const abi = ["function initialize() public"];
    const proxied = new ethers.Contract(proxy.address, abi, owner);

    await proxied.initialize();
  });

  it("points to an implementation contract", async () => {
    expect(await proxy.callStatic.getImplementation()).to.eq(shoppingv1.address);
  });

  it("cannot be initialized twice", async () => {
    abi = ["function initialize() public"];
    const proxied = new ethers.Contract(proxy.address, abi, owner);

    await expect(proxied.initialize()).to.be.revertedWith(
      "already initialized"
    );
  });

  it("allows to change implementations", async () => {
    const Shoppingv2 = await ethers.getContractFactory("Shoppingv2");
    shoppingv2 = await Shoppingv2.deploy();
    await shoppingv2.deployed();

    await proxy.setImplementation(shoppingv2.address);

    abi = [
      "function initialize() public",
      "addToCart(string[] memory goods, uint256[] memory prices) public",
      "checkout(string[] memory goods, uint256[] memory prices) public",
      "function getTotal(address shopper) public view returns(uint256)",
    ];

    const proxied = new ethers.Contract(proxy.address, abi, owner);

    
  });
});