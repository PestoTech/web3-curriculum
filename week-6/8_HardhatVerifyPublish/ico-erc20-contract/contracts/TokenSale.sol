// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale is Ownable {
    IERC20 public token;
    uint256 public pricePerEth;

    event TokenSold(
        address indexed buyer,
        address indexed seller,
        uint256 indexed saleCount
    );

    constructor(address _token, uint256 _pricePerEth) {
        token = IERC20(_token);
        pricePerEth = _pricePerEth;
    }

    function buyTokens() external payable {
        require(msg.value >= 100000000000000000 wei, "Required Ether not sent");

        uint256 saleCount = msg.value * pricePerEth;

        require(
            token.transferFrom(owner(), msg.sender, saleCount),
            "Transfer Failed"
        );

        emit TokenSold(msg.sender, address(this), saleCount);
    }
}

/* As an extended activity add the below functionalities to the Token Sale contract
1. The TokenSale contract does not check if there are sufficient tokens available for sale. 
   Add relevant checks to this contract.
2. Ether / Matic is getting accumulated in this contract on each sale. 
   Add functionality such that only the owner of the contract can withdraw funds from this contract.
*/
