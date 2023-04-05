// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract RewardToken is ERC20, Ownable {

    constructor( string memory _name, string memory _symbol) ERC20(_name, _symbol) {

    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}