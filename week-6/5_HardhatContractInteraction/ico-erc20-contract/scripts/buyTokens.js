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

async function main() {

    // Contracts are deployed using the first signer/account by default
    const [deployer, tokenBuyer] = await hre.ethers.getSigners();

    // Contract is an Ethers.js object that represents a specific contract deployed on-chain
    const mpg = new hre.ethers.Contract(MyPestoGemsContractAddress, MyPestoGemsArtifact.abi, deployer);

    const tokenSale = new hre.ethers.Contract(TokenSaleContractAddress, TokenSaleArtifact.abi, deployer);

    // Here we can use all the contract functions like we did during the testing
    console.log('-------------------------Initial State---------------------------');
    let tokenName = await mpg.name();
    console.log(`Token Name: ${tokenName}`);
    let tokenSupply = await mpg.totalSupply();
    console.log(`Token Supply: ${hre.ethers.utils.formatEther(tokenSupply)} MPG`);
    let initialBalance = await mpg.balanceOf(deployer.address);
    console.log(`MPG Creator owned tokens: ${ hre.ethers.utils.formatEther(initialBalance)} MPG`);

    let tokenSaleOwner = await tokenSale.owner();
    console.log(`TokenSale Owner: ${tokenSaleOwner}`);

    let icoContractInitalFunds = await ethers.provider.getBalance(tokenSale.address);
    console.log(`Initial TokenSale Balance: ${icoContractInitalFunds}`);

    console.log('-------------------------Approval Transaction---------------------------');
    
    // Provide required approval
    const approvalTX = await mpg.approve(tokenSale.address, tokenSupply);
    await approvalTX.wait();
    /* A call to .wait() on the returned transaction object. 
       This ensures that our script waits for the transaction to be mined on the blockchain
       before proceeding onwards. 
    */
    console.log(approvalTX);

    // Log the approved limit
    let allowance = await mpg.allowance(deployer.address, tokenSale.address);
    console.log(`Approved Alloance: ${hre.ethers.utils.formatEther(allowance)}`);

    // Buy Tokens
    const ONE_ETH = ethers.utils.parseEther("1.0");
    console.log('-------------------------BuyTokens Transaction---------------------------');
    let buyTx = await tokenSale.connect(tokenBuyer).buyTokens({ value: ONE_ETH });
    await buyTx.wait();
    console.log(buyTx);

    console.log('-------------------------Final State---------------------------');
    
    let balanceAfterBuy = await mpg.balanceOf(deployer.address);
    console.log(`MPG Creator owned tokens: ${ hre.ethers.utils.formatEther(balanceAfterBuy)} MPG`);

    let buyerBalance = await mpg.balanceOf(tokenBuyer.address);
    console.log(`Buyer owned tokens: ${ hre.ethers.utils.formatEther(buyerBalance)} MPG`);

    let icoContractFunds = await ethers.provider.getBalance(tokenSale.address);
    console.log(`Final TokenSale Balance: ${hre.ethers.utils.formatEther(icoContractFunds)} ETH`);
}

// Use this pattern to be able to use async/await everywhere and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});