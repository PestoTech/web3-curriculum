// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title StringEquality
 * Contract to string equality using hashing functions.
 * This sample uses keccak256, similar functions sha256, ripemd160 can also be used
 */
contract StringEquality {

    /**
     * @dev checkForEquality using keccak256
     * @param str1 first string
     * @param str2 second string
     * @return equality status
     *
     * Example1: "Hello" & "Hello"
     * Returns: true
     *
     * Example1: "Hello" & "hello"
     * Returns: false
     *
     * Example1: "Hello" & "ello"
     * Returns: Throws an revert message 'Unequal length'
     */
    function checkForEquality(string memory str1, string memory str2 ) public pure returns (bool ) {

        uint256 len1 = bytes(str1).length;  // Because, string does not have length member variable
        uint256 len2 = bytes(str2).length;  

        require(len1 == len2, "Unequal length");

        bytes memory str1Bytes =  bytes(str1);
        bytes32 hashStr1 = keccak256(str1Bytes);

        bytes memory str2Bytes =  bytes(str2);
        bytes32 hashStr2 = keccak256(str2Bytes);

        // This can be done by inlining the functions: keccak256(bytes(str1)) == keccak256(bytes(str2))
        if(hashStr1 == hashStr2) {
            return true;
        } else {
            return false;
        }
        
    }

}