/* Hardhat Runtime Environment is not required here if the below command is used:
   'npx hardhat run ./scripts/deploy.js'
   ethers from the nomic foundation is sufficient.
   It is useful for running the script in a standalone fashion through: 'node ./scripts/deploy.js.
*/

const hre = require("hardhat");

// Resuing the old MyPestoGems token address
const {MyPestoGemsContractAddress} = require("./constants");

async function main() {
    
    const SUPPLY = "1000000"; // A million
    const PRICE_PER_ETH = 100;
    const TOTAL_TOKEN_SUPPLY = hre.ethers.utils.parseEther(SUPPLY);

    // Contracts are deployed using the first signer/account by default
    const [deployer, tokenBuyer] = await hre.ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    /*
      Pick the relevant contract artifacts from the artifacts directory
      A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
      so TokenSaleFlat here is a factory for instances of our TokenSaleFlat contract.
      The hardhat-ethers plugin ContractFactory and Contract, instances are connected
      to the first signer (owner) by default.
    */
    const TokenSaleFlat = await hre.ethers.getContractFactory("TokenSaleFlat");
    /* Deploy an instance of the contract
       Calling deploy() on a ContractFactory will start the deployment,
       and return a Promise that resolves to a Contract object.
       This is the object that has a method for each of our smart contract functions.
    */
    const tokenSale = await TokenSaleFlat.deploy(MyPestoGemsContractAddress, PRICE_PER_ETH);
    // Wait for the contract to be deployed
    await tokenSale.deployed();
    console.log(`Contract TokenSaleFlat is deployed at ${tokenSale.address}`);
}

// Use this pattern to be able to use async/await everywhere and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});