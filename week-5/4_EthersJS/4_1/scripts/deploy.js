// This script can be used to deploy the "MyPestoGems" contract using ethers.js library.
// Please make sure to contract is compiled or enable auto compile enabled before running this script.
// And use Right click -> "Run" from context menu of the file to run the script.
import { ethers } from 'ethers'

(async () => {
    try {
            console.log(`deploying MyPestoGems...`);
            // Note that the script needs the ABI which is generated from the compilation artifact.
            // Make sure contract is compiled and artifacts are generated
            const artifactsPath = `browser/week-5/4_EthersJS/4_1/contracts/artifacts/MyPestoGems.json`;

            const metadata = JSON.parse(await remix.call('fileManager', 'getFile', artifactsPath));
            
            // 'web3Provider' is a remix global variable object
            const provider = new ethers.providers.Web3Provider(web3Provider);
            console.log(`logging provider...`);
            console.log(provider);
    
            const signer = provider.getSigner(0);
            console.log(`logging signer...`);
            console.log(signer);

            const factory = new ethers.ContractFactory(metadata.abi, metadata.data.bytecode.object, signer);

            const contract = await factory.deploy(ethers.utils.parseUnits("1000"));

            // The contract is NOT deployed yet; we must wait until it is mined
            await contract.deployed();
            console.log(`logging contract...`);
            console.log(contract);

            // Listen to all Transfer events:
            contract.on("Transfer", (from, to, amount, event) => {
                // log all data
                console.log(`from: ${from}`);
                console.log(`to: ${to}`);
                console.log(`amount: ${amount}`);
                console.log('event data:');
                console.log(event);
            });

            console.log(`address: ${contract.address}`);

            console.log(`ETH Balance: ${await signer.getBalance()}`);

            console.log(`token balance of deployer, before mint: ${await contract.balanceOf(signer.getAddress())}`);

            // minting the tokens for the deployer
            let tx = await contract.mint(signer.getAddress(), ethers.utils.parseUnits("1000"));

            console.log(`token balance of deployer, after mint: ${await contract.balanceOf(signer.getAddress())}`);

            // fetching another address for transfer
            const signer_1 = provider.getSigner(1);

            // sending the tokens to another address
            tx = await contract.transfer(signer_1.getAddress(), ethers.utils.parseUnits("100"));

            await tx.wait();

            console.log(`logging transfer tx...`);
            console.log(tx);

            console.log(`token balance of deployer, after transfer: ${await contract.balanceOf(signer.getAddress())}`);
            console.log(`token balance of receiver, after transfer: ${await contract.balanceOf(signer_1.getAddress())}`);

    } catch (e) {
        console.log(e.message)
    } finally {
            // unsubscribe to all Transfer events:
            contract.off("Transfer", (from, to, amount, event) => {
            });
    }
  })()