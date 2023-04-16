/* Hardhat Runtime Environment is not required here if the below command is used:
   'npx hardhat run ./scripts/buyTokens'
   ethers from the nomic foundation is sufficient.
   It is useful for running the script in a standalone fashion through:
   'node ./scripts/buyTokens.
*/

const hre = require("hardhat");

const {MyPestoGemsContractAddress, TokenSaleContractAddress} = require('./constants');
const MyPestoGemsArtifact = require("../artifacts/contracts/MyPestoGems.sol/MyPestoGems.json");
const TokenSaleArtifact = require("../artifacts/contracts/TokenSale.sol/TokenSale.json");
const MyPestoGemsV2Artifact = require("../artifacts/contracts/MyPestoGemsV2.sol/MyPestoGemsV2.json");
const TokenSaleV2Artifact = require("../artifacts/contracts/TokenSaleV2.sol/TokenSaleV2.json");

async function main() {

    // Contracts are deployed using the first signer/account by default
    const [deployer, tokenBuyer] = await hre.ethers.getSigners();

    // Upgrade to new implementations
    const MPGV2 = await ethers.getContractFactory("MyPestoGemsV2");
    const mpgv2 = await upgrades.upgradeProxy(MyPestoGemsContractAddress, MPGV2);
    
    const TokenSaleV2 = await ethers.getContractFactory("TokenSaleV2");
    const tokenSalev2 = await upgrades.upgradeProxy(TokenSaleContractAddress, TokenSaleV2);


    // Here we can use all the contract functions like we did during the testing
    console.log('------------------------- State after buy tokens---------------------------');
    let tokenName = await mpgv2.name();
    console.log(`Token Name: ${tokenName}`);
    let tokenSupply = await mpgv2.totalSupply();
    console.log(`Token Supply: ${hre.ethers.utils.formatEther(tokenSupply)} MPG`);
    let initialBalance = await mpgv2.balanceOf(deployer.address);
    console.log(`MPG Creator owned tokens: ${ hre.ethers.utils.formatEther(initialBalance)} MPG`);

    let tokenSaleOwner = await tokenSalev2.owner();
    console.log(`TokenSale Owner: ${tokenSaleOwner}`);

    let icoContractInitalFunds = await ethers.provider.getBalance(tokenSalev2.address);
    console.log(`Initial TokenSale Balance: ${icoContractInitalFunds}`);

    console.log('-------------------------Withdraw Funds from updated TokenSale---------------------------');
    
    const withdrawTx = await tokenSalev2.withdraw();
    await withdrawTx.wait();
    console.log(withdrawTx);

    console.log('-------------------------Burn certain tokens MyPestoGems---------------------------');

    const burnTx = await mpgv2.burn(ethers.utils.parseEther("100"));
    await burnTx.wait();
    console.log(burnTx);

    console.log('-------------------------Final State after withdraw and burn---------------------------');
    
    let balanceAfterBuy = await mpgv2.balanceOf(deployer.address);
    console.log(`MPG Creator owned tokens: ${ hre.ethers.utils.formatEther(balanceAfterBuy)} MPG`);

    let icoContractFunds = await ethers.provider.getBalance(tokenSalev2.address);
    console.log(`Final TokenSale Balance: ${hre.ethers.utils.formatEther(icoContractFunds)} MATIC`);
}

// Use this pattern to be able to use async/await everywhere and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});