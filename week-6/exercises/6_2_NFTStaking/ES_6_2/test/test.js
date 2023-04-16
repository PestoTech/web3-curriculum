const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

/**
 * While it is best to test all the contracts,
 * The implementation will carry only the testing of Stacking Contract
 * as the rest are small modifications over the OZ standards
 */

describe("Stacking Contract Testing", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFixture() {

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const stakingNFTFactory = await ethers.getContractFactory("StakingNFT");
    const stakingNFT = await stakingNFTFactory.deploy();

    const stakingContractFactory = await ethers.getContractFactory("StakingContract");
    const stakingContract = await stakingContractFactory.deploy();

    const rewardTokenAddress = await stakingContract.rToken();
    const rewardToken = await ethers.getContractAt("RewardToken", rewardTokenAddress);

    return { stakingNFT, stakingContract, rewardToken, owner, otherAccount };
  }

  describe("Functionality", function () {
    it("User mint and Stake", async function () {
      const { stakingNFT, stakingContract, otherAccount } = await loadFixture(deployFixture);

      await stakingNFT.connect(otherAccount).safeMint();

      const FIRST_TOKEN = 1;

      expect (await stakingNFT.balanceOf(otherAccount.address)).to.be.eq(FIRST_TOKEN);

      expect (await stakingNFT.ownerOf(FIRST_TOKEN)).to.be.eq(otherAccount.address);

      await stakingNFT.connect(otherAccount).approve(stakingContract.address, FIRST_TOKEN);

      await stakingContract.connect(otherAccount).stakeNFT(stakingNFT.address, FIRST_TOKEN);

      expect (await stakingNFT.ownerOf(FIRST_TOKEN)).to.be.eq(stakingContract.address);

    });

    it("User Stake invalid collection reverts", async function () {
      const { stakingNFT, stakingContract, otherAccount } = await loadFixture(deployFixture);

      await stakingNFT.connect(otherAccount).safeMint();

      await expect(stakingContract.connect(otherAccount).stakeNFT(ethers.constants.AddressZero , 1)).be.revertedWith(
            "Invalid Collection"
      );
    });
  });

  describe("UnStake", function () {
      it("Stake and unstake after certain time", async function () {
        const { stakingNFT, stakingContract, rewardToken, otherAccount } = await loadFixture(deployFixture);

        //Minting and Staking
        await stakingNFT.connect(otherAccount).safeMint();
  
        const FIRST_TOKEN = 1;
  
        expect (await stakingNFT.balanceOf(otherAccount.address)).to.be.eq(FIRST_TOKEN);
  
        expect (await stakingNFT.ownerOf(FIRST_TOKEN)).to.be.eq(otherAccount.address);
  
        await stakingNFT.connect(otherAccount).approve(stakingContract.address, FIRST_TOKEN);
        
        const currentTime = await time.latest();
        await stakingContract.connect(otherAccount).stakeNFT(stakingNFT.address, FIRST_TOKEN);
  
        expect (await stakingNFT.ownerOf(FIRST_TOKEN)).to.be.eq(stakingContract.address);

        // Wait for few minutes
        // We can increase the time in Hardhat Network
        const OneHourLater = currentTime + 3600; //(1 hour has 3600 seconds)
        await time.increaseTo(OneHourLater);

        await stakingContract.connect(otherAccount).unStake(stakingNFT.address, FIRST_TOKEN);
        expect (await stakingNFT.ownerOf(FIRST_TOKEN)).to.be.eq(otherAccount.address);
        expect (await rewardToken.balanceOf(otherAccount.address)).to.be.greaterThan(ethers.utils.parseEther("59"));

      });

      it("Invalid unstake reverts", async function () {
        const { stakingNFT, stakingContract, rewardToken, otherAccount } = await loadFixture(deployFixture);

        //Minting and Staking
        await stakingNFT.connect(otherAccount).safeMint();
  
        const FIRST_TOKEN = 1;
        const INVALID_TOKEN = 10;
  
        expect (await stakingNFT.balanceOf(otherAccount.address)).to.be.eq(FIRST_TOKEN);
  
        expect (await stakingNFT.ownerOf(FIRST_TOKEN)).to.be.eq(otherAccount.address);
  
        await stakingNFT.connect(otherAccount).approve(stakingContract.address, FIRST_TOKEN);
        
        const currentTime = await time.latest();
        await stakingContract.connect(otherAccount).stakeNFT(stakingNFT.address, FIRST_TOKEN);
  
        expect (await stakingNFT.ownerOf(FIRST_TOKEN)).to.be.eq(stakingContract.address);

        // Wait for few minutes
        // We can increase the time in Hardhat Network
        const OneHourLater = currentTime + 3600; //(1 hour has 3600 seconds)
        await time.increaseTo(OneHourLater);

        await expect (stakingContract.connect(otherAccount).unStake(stakingNFT.address, INVALID_TOKEN)).to.be.revertedWith("Invalid collection or token id");

      });
    });


    
});
