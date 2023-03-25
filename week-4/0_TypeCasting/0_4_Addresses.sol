// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

interface CallMeInterface {
    function callMe() external;
} 

contract Example {

    function demo() public {

        address a = msg.sender;
        console.log(a);   // Output: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

        // TypeError: "send" and "transfer" are only available for objects of type "address payable", not "address".
        // a.transfer( 1 ether);

        // Making a address payable
        address payable payableA = payable(a);
        console.log(payableA);      // Output: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        payableA.transfer(0 ether);

        // Cast from this contract instance to address
        address thisAddress = address(this);
        console.log(thisAddress);     // Output: 0xd9145CCE52D386f254917e481eB44e9943F39138
    
        // Cast to bytes20
        bytes20 b = bytes20(a);

        //Cast to uint160
        uint160 c = uint160(a);
        console.log(c);     // Output: 520786028573371803640530888255888666801131675076
    }

    function makeAddress() external view returns (bytes32 hash) {
        // Using current blockhash to generate a address
        uint256 blockTime = block.timestamp;
        hash = keccak256(abi.encode(blockTime));

        // generating two different addresses
        address newAddress = address(bytes20(hash));
        console.log(newAddress); // Output uses first 20 bytes of the hash

        // generating two different addresses
        newAddress = address(uint160(uint256(hash)));
        console.log(newAddress); // Output uses last 20 bytes of the hash
    }    
}