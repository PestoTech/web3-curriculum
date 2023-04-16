require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();       // include dotenv dependency

const { ALCHEMY_API_URL, PRIVATE_KEY_1, PRIVATE_KEY_2, MNEMONICS, POLYGON_SCAN_API } = process.env; // Javascript destructuring

module.exports = {
  defaultNetwork: "hardhat",
	networks: {
		localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {
      // default field values picked
      loggingEnabled: false
    },
    polygonMumbai: {
      url: ALCHEMY_API_URL,
      accounts: {
        mnemonic: MNEMONICS,
        count: 2
      },
    }

	}, 
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  etherscan: {
    apiKey: {
        polygonMumbai: POLYGON_SCAN_API,
    }
  },
};
