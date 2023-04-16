// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Note the use of upgradeable contracts here

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

// MyPestoGems is an ERC20Upgradeable token
contract MyPestoGemsV2 is
    Initializable,
    ERC20Upgradeable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    PausableUpgradeable
{
    function initialize(uint256 _initalSupply) public initializer {
        //Calling the initializer functions of the base contracts explicitly
        __ERC20_init("MyPestoGems", "MPG");
        __UUPSUpgradeable_init();
        __Ownable_init();
        //mint initial supply  tokens to the deployer
        // '**' means to the power, here 10 power 18
        _mint(_msgSender(), _initalSupply * 10 ** 18);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        _spendAllowance(account, _msgSender(), amount);
        _burn(account, amount);
    }
}
