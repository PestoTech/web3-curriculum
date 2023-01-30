const {
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

//The string usually describes the contract that is being tested.
describe("TokenSale", function () {

    // A fixture in hardhat is like beforeEach just that it is more optimized.
    // Hardhat uses loadFixture to run this setup once, snapshot that state.
    // Upon subsequent calls to loadFixture with the same function,
    // rather than executing the function again, the blockchain will be restored
    // to that snapshot.
    async function deployContracts() {
        
        const SUPPLY = "1000000"; // A million
        const PRICE_PER_ETH = 100;
        const TOTAL_TOKEN_SUPPLY = ethers.utils.parseEther(SUPPLY);

        // Contracts are deployed using the first signer/account by default
        const [tokenCreator, tokenBuyer] = await ethers.getSigners();

        // Pick the relevant mock contract artifacts from the artifacts directory
        const MOCK_MGP = await ethers.getContractFactory("MockPestoGems");

        // Deploy an instance of the contract
        const mock_mpg = await MOCK_MGP.deploy(SUPPLY);

        const TokenSale = await ethers.getContractFactory("TokenSale");
        const tokenSale = await TokenSale.deploy(mock_mpg.address, PRICE_PER_ETH);

        return { mock_mpg, tokenSale, tokenCreator, tokenBuyer, TOTAL_TOKEN_SUPPLY };
    }

    //The nested describe statements state the task being done
    describe("Deployment", function () {
        it("Should set the right token states [@skip-on-coverage]", async function () {
            const { mock_mpg, tokenCreator, TOTAL_TOKEN_SUPPLY } = await loadFixture(deployContracts);

            // Testing the basic token states
            expect(await mock_mpg.name()).to.equal("MyPestoGems");            
            expect(await mock_mpg.totalSupply()).to.equal(TOTAL_TOKEN_SUPPLY);
        });

        it("Should have right TokenSale states [@skip-on-coverage]", async function () {
            const { tokenSale, tokenCreator } = await loadFixture(deployContracts);
            expect(await tokenSale.owner()).to.equal(tokenCreator.address);
            expect(await ethers.provider.getBalance(tokenSale.address)).to.equal(0);
        });
    });

    describe("Token Sale Transactions", function () {
        it("Should be successful if required allowance is provided [@skip-on-coverage]", async function () {
            const ONE_ETH = ethers.utils.parseEther("1.0");
            const { mock_mpg, tokenSale, tokenCreator, tokenBuyer, TOTAL_TOKEN_SUPPLY } = await loadFixture(deployContracts);
            // Provide required approval
            await mock_mpg.approve(tokenSale.address, TOTAL_TOKEN_SUPPLY);
            // Buy Tokens. This also checks if the token balances are updated
            await tokenSale.connect(tokenBuyer).buyTokens({ value: ONE_ETH });                
        });
    });
});
