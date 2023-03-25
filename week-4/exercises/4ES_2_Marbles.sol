// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title Marbles
 * Contract to maintains the account of marbles
 *
 *  Write a contract that maintains the account of the number of marbles an address has.
 *   1. The contract shall allow the address to open the account with a limited number of marbles. One-time activity only
 *   2. The contract shall allow anybody to check how many marbles a particular address has.
 *   3. Update the balance number of marbles after a successful exchange. Only allowed by the Exchange contract.
 *
 */

contract Marbles {

    address owner;
    address exchange;
    mapping( address => uint256 ) marbleBalance;
    mapping( address => bool ) openStatus;

    error alreadyOpened();

    modifier exchangeOnly () {
        require(exchange == msg.sender, "Exchange only operation");
        _;
    }

    constructor() {
        exchange = msg.sender;
    }

    function openAccount(uint256 numMarbles) external {
        if(openStatus[msg.sender]) {
            revert alreadyOpened();
        }

        marbleBalance[msg.sender] = numMarbles;
        openStatus[msg.sender] = true;
    }

    function balance(address user) external view  returns (uint256 ) {
        return marbleBalance[user];
    }

    function updatebalance(address from, address to, uint256 count ) external exchangeOnly {
        marbleBalance[from] -= count;
        marbleBalance[to] += count;
        if(openStatus[to] == false) {
            openStatus[to] = true;
        }
    }
}