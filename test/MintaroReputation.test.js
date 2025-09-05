const { expect } = require("chai");

describe("MintaroReputation", function () {
  let mintaro, client, freelancer;

  beforeEach(async function () {
    const MintaroReputation = await ethers.getContractFactory("MintaroReputation");
    [client, freelancer] = await ethers.getSigners();
    mintaro = await MintaroReputation.deploy();
    await mintaro.deployed();
  });

  it("should mint a badge with rating and store metadata", async function () {
    const tx = await mintaro.connect(client).mintBadge(freelancer.address, 5, "ipfs://review1");
    await tx.wait();

    const badge = await mintaro.badgeDetails(0);
    expect(badge.freelancer).to.equal(freelancer.address);
    expect(badge.rating).to.equal(5);
    expect(badge.ipfsCID).to.equal("ipfs://review1");

    const badges = await mintaro.getBadgesOf(freelancer.address);
    expect(badges.length).to.equal(1);
    expect(badges[0]).to.equal(0);
  });
});
