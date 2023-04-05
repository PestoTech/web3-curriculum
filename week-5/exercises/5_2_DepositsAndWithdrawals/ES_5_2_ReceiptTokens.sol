// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract ReceiptTokens is ERC20, Ownable {
    address public _underlyingToken;

    constructor(
        address underlyingToken,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        require(underlyingToken != address(0), "ZeroAddress failure");
        _underlyingToken = underlyingToken;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    // choose appropraite decimals as per the underlying token
    function decimals() public view virtual override returns (uint8) {
        return ERC20(_underlyingToken).decimals();
    }
}