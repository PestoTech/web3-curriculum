// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Marbles is ERC20 {

    mapping(address => bool) minted;

    error ZeroAmount();
    error MintOnceOnly();
    
    // Note the call of constructors from ERC20 and ERC20Capped
    constructor() ERC20("Marbles", "MARB") {

    }

    function mint(uint256 amount) public {

        if(amount == 0) {
            revert ZeroAmount();
        }

        if(minted[msg.sender]) {
            revert MintOnceOnly();
        }

        _mint(msg.sender, amount);
        minted[msg.sender] = true;
    }

    // This is a special case as i do not want to allow for fractional ownership of Marbles
    function decimals() public view virtual override returns (uint8) {
        return 1;
    }
}
