// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Note the use of upgradeable contracts here
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// MyPestoGems is an ERC20Upgradeable token
// Basic implementation of ERC20Upgradeable token standard is already provided by openzeppelin
contract MyPestoGems is
    Initializable,
    ERC20Upgradeable,
    UUPSUpgradeable,
    OwnableUpgradeable
{
    function initialize(uint256 _initalSupply) public initializer {
        //Calling the ERC20Upgradeable's initializer function explicitly
        __ERC20_init("MyPestoGems", "MPG");
        __Ownable_init();
        __UUPSUpgradeable_init();
        //mint initial supply  tokens to the deployer
        // '**' means to the power, here 10 power 18
        _mint(msg.sender, _initalSupply * 10 ** 18);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}
