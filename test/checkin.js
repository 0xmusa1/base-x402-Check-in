const { expect } = require("chai");

describe("BaseX402CheckIn", function () {
  let contract, owner;

  beforeEach(async () => {
    const Contract = await ethers.getContractFactory("BaseX402CheckIn");
    contract = await Contract.deploy();
    await contract.waitForDeployment();

    [owner] = await ethers.getSigners();
  });

  it("should allow check-in", async () => {
    await contract.checkIn();
    expect(await contract.tokenIdCounter()).to.equal(1);
  });

  it("should prevent double check-in in 24h", async () => {
    await contract.checkIn();
    await expect(contract.checkIn()).to.be.reverted;
  });
});
