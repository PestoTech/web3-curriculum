// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./4ES_2_Marbles.sol";

/**
 * @title ExchangeETHForMarbles
 * Exchange that facilitates the exchange of ETH for marbles
 *  Write another contract called the `Exchange` that allows for deals between
 *   1. The exchange contract shall allow for exchanges of Ether for marble at a fixed price set in the contract during its creation.
 *   2. The exchange shall check if the address with marbles has the required number of marbles and swap the required Ether for marbles.
 *   3. Throws an error when the required marbles or Ether is not sent to the contract.  
 *   4. Only the exchange shall be able to update the marble balance on a successful Marble_Ether exchange.
 *
 */

contract ExchangeETHForMarbles {

    uint256 public priceInWei;
    Marbles public marbles;

    event Trade(address from, address to, uint256 count);

    constructor(uint256 _price) {
        marbles = new Marbles() ;
        priceInWei = _price;
    }

    function calculateETHAmount(uint256 count) public view returns(uint256 payment) {
        return count * priceInWei;
    }

    function exchange(address from, uint256 count) external payable {
        uint256 requiredAmount = calculateETHAmount(count);

        require(msg.value >= requiredAmount, "Insuffcient payment");
        require(marbles.balance(from) >= count, "Insufficient marbles");

        marbles.updatebalance(from, msg.sender, count);
        
        emit Trade(from, msg.sender, count);
        
        payable(msg.sender).transfer(requiredAmount);
    }
}