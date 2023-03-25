// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Example {
    function printValue(uint256 value) public view {
        // some logic here
    }

    function callPrintValue(uint8 smallValue) public view {
        // small(uint8) implicitly converted to a wider value(uint256)
        printValue(smallValue);
    }

    function printPayableAddress(address payable payableAddress) public view {
        // Some logic here
    }

    // No implicit conversions between address types
    function callPrintPayableAddress() public view {

        address address1 = msg.sender;
        address payable address2 = payable (msg.sender);

        printPayableAddress(address2);
        
        // Error cases
        // printAddress(address1); // Explicit conversion required
        // printAddress(address(this)); // Explicit conversion required
    }


    function printAddress(address regularAddress) public view {
        // Some logic here
    }

    // No implicit conversions between address types
    function callPrintAddress() public view {

        address address1 = msg.sender;
        address payable address2 = payable (msg.sender);

        printAddress(address2); // Note the implicit conversion between payable address to address here
    }
}