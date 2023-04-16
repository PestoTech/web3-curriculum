const {
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
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
        const [tokenCreator, tokenBuyer, hacker] = await ethers.getSigners();

        // Pick the relevant contract artifacts from the artifacts directory
        const MPG = await ethers.getContractFactory("MyPestoGems");

        // Deploy an instance of the contract
        const mpg = await MPG.deploy(SUPPLY);

        const TokenSale = await ethers.getContractFactory("TokenSale");
        const tokenSale = await TokenSale.deploy(mpg.address, PRICE_PER_ETH);

        return { mpg, tokenSale, tokenCreator, tokenBuyer, TOTAL_TOKEN_SUPPLY, hacker };
    }

    //The nested describe statements state the task being done
    describe("Deployment", function () {
        it("Should set the right token states", async function () {
            const { mpg, tokenCreator, TOTAL_TOKEN_SUPPLY } = await loadFixture(deployContracts);

            // Testing the basic token states
            expect(await mpg.name()).to.equal("MyPestoGems");            
            expect(await mpg.totalSupply()).to.equal(TOTAL_TOKEN_SUPPLY);
            expect(await mpg.balanceOf(tokenCreator.address)).to.equal(TOTAL_TOKEN_SUPPLY);
        });

        it("Should have right TokenSale states", async function () {
            const { tokenSale, tokenCreator } = await loadFixture(deployContracts);
            expect(await tokenSale.owner()).to.equal(tokenCreator.address);
            expect(await ethers.provider.getBalance(tokenSale.address)).to.equal(0);
        });
    });

    describe("Token Sale Transactions", function () {
        //Check for reverts thrown during error conditions
        describe("Validations", function () {
            // No ether is sent for buying the tokens
            it("Should revert with the right error if no ether is sent", async function () {
                const { tokenSale, tokenBuyer } = await loadFixture(deployContracts);

                // Check for required revert
                await expect(tokenSale.connect(tokenBuyer).buyTokens()).to.be.revertedWith(
                    "Required Ether not sent"
                );
            });

            // Ether sent but the TokenSale contract does not have approval
            it("Should revert with the right allowance", async function () {
                const ONE_ETH = ethers.utils.parseEther("1.0");
                const { tokenSale, tokenBuyer } = await loadFixture(deployContracts);

                // Check for required revert
                await expect(tokenSale.connect(tokenBuyer).buyTokens({ value: ONE_ETH })).to.be.revertedWith(
                    "ERC20: insufficient allowance"
                );
            });

            it("Should be successful if required allowance is provided", async function () {
                const ONE_ETH = ethers.utils.parseEther("1.0");
                const { mpg, tokenSale, tokenCreator, tokenBuyer, TOTAL_TOKEN_SUPPLY } = await loadFixture(deployContracts);

                // Provide required approval
                await mpg.approve(tokenSale.address, TOTAL_TOKEN_SUPPLY);

                // Check if the approval is provided
                expect (await mpg.allowance(tokenCreator.address, tokenSale.address)).to.be.equal(TOTAL_TOKEN_SUPPLY);

                // Buy Tokens. This also checks if the token balances are updated
                await expect(tokenSale.connect(tokenBuyer).buyTokens({ value: ONE_ETH })).to.changeTokenBalances(
                    mpg,
                    [tokenCreator, tokenBuyer],
                    [ ethers.utils.parseEther("-100.0"), ethers.utils.parseEther("100.0")]
                  );
                
            });
        });

        // This is to check how to expect events and how to check for their arguments
        describe("Events", function () {
            it("Should emit an event on TokenSale", async function () {
                const ONE_ETH = ethers.utils.parseEther("1.0");
                const { mpg, tokenSale, tokenCreator, tokenBuyer, TOTAL_TOKEN_SUPPLY } = await loadFixture(deployContracts);

                // expect event without event arguments
                await expect (mpg.approve(tokenSale.address, TOTAL_TOKEN_SUPPLY)).to.emit(mpg, "Approval");

                // expect (await mpg.allowance(tokenCreator.address, tokenSale.address)).to.be.equal(TOTAL_TOKEN_SUPPLY);

                // expect event with event arguments
                // anyvalue is a ignore value
                await expect(tokenSale.connect(tokenBuyer).buyTokens({ value: ONE_ETH })).to.emit(tokenSale, "TokenSold")
                    .withArgs(tokenBuyer.address, tokenSale.address, anyValue);
            });
        });

        // This is to check ETH transfer during transactions
        describe("Transfers", function () {
            it("Should transfer the funds to the owner", async function () {
                const ONE_ETH = ethers.utils.parseEther("1.0");
                const { mpg, tokenSale, tokenCreator, tokenBuyer, TOTAL_TOKEN_SUPPLY } = await loadFixture(deployContracts);

                await mpg.approve(tokenSale.address, TOTAL_TOKEN_SUPPLY);

                expect (await mpg.allowance(tokenCreator.address, tokenSale.address)).to.be.equal(TOTAL_TOKEN_SUPPLY);

                await expect(tokenSale.connect(tokenBuyer).buyTokens({ value: ONE_ETH })).to.changeEtherBalances(
                    [tokenSale, tokenBuyer],
                    [ONE_ETH, ethers.utils.parseEther("-1.0")]
                );
            });
        });

        // This is to check if withdrawals work as expected
        describe("Withdrawals", function () {
            it("Non owner reverts on withdraw", async function () {
                const ONE_ETH = ethers.utils.parseEther("1.0");
                const { mpg, tokenSale, tokenCreator, tokenBuyer, TOTAL_TOKEN_SUPPLY, hacker } = await loadFixture(deployContracts);

                await mpg.approve(tokenSale.address, TOTAL_TOKEN_SUPPLY);

                expect (await mpg.allowance(tokenCreator.address, tokenSale.address)).to.be.equal(TOTAL_TOKEN_SUPPLY);

                await expect(tokenSale.connect(tokenBuyer).buyTokens({ value: ONE_ETH })).to.changeEtherBalances(
                    [tokenSale, tokenBuyer],
                    [ONE_ETH, ethers.utils.parseEther("-1.0")]
                );

                await expect(tokenSale.connect(hacker).withdrawAll()).to.be.revertedWith(
                    "Ownable: caller is not the owner"
                );
            });

            it("owner shall be able to withdraw funds", async function () {
                const ONE_ETH = ethers.utils.parseEther("1.0");
                const { mpg, tokenSale, tokenCreator, tokenBuyer, TOTAL_TOKEN_SUPPLY, hacker } = await loadFixture(deployContracts);

                await mpg.approve(tokenSale.address, TOTAL_TOKEN_SUPPLY);

                expect (await mpg.allowance(tokenCreator.address, tokenSale.address)).to.be.equal(TOTAL_TOKEN_SUPPLY);

                await expect(tokenSale.connect(tokenBuyer).buyTokens({ value: ONE_ETH })).to.changeEtherBalances(
                    [tokenSale, tokenBuyer],
                    [ONE_ETH, ethers.utils.parseEther("-1.0")]
                );

                await expect(tokenSale.connect(tokenCreator).withdrawAll()).to.changeEtherBalances(
                    [tokenSale, tokenCreator],
                    [ ethers.utils.parseEther("-1.0"), ONE_ETH ]
                );
            });
        });

        describe("Setup and Test for Insuffucient Tokens for sale", function () {
            it("Should revert when tokens beyond supply is requested", async function () {
                // Not using the fixture as it is hardcoded to do mint million tokens already.

                const tSUPPLY = "1000"; // A thousand
                const PRICE_PER_ETH = 100;
                const t_TOTAL_TOKEN_SUPPLY = ethers.utils.parseEther(tSUPPLY);
                const WHALE_BUY_AMOUNT = ethers.utils.parseEther("10.1");

                // Contracts are deployed using the first signer/account by default
                const [tokenCreator, tokenBuyer] = await ethers.getSigners();

                // Pick the relevant contract artifacts from the artifacts directory
                const MPG = await ethers.getContractFactory("MyPestoGems");

                // Deploy an instance of the contract
                const mpg = await MPG.deploy(tSUPPLY);

                const TokenSale = await ethers.getContractFactory("TokenSale");
                const tokenSale = await TokenSale.deploy(mpg.address, PRICE_PER_ETH);
                
                await mpg.approve(tokenSale.address, t_TOTAL_TOKEN_SUPPLY);

                expect (await mpg.allowance(tokenCreator.address, tokenSale.address)).to.be.equal(t_TOTAL_TOKEN_SUPPLY);

                await expect(tokenSale.connect(tokenBuyer).buyTokens({ value: WHALE_BUY_AMOUNT })).to.be.revertedWith("Too Many Tokens requested");
            });
        });
    });
});
