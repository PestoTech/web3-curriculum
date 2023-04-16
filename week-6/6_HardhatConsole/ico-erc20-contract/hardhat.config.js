require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  defaultNetwork: "hardhat",
	networks: {
		localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {
      // default field values picked
      loggingEnabled: true
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
};
