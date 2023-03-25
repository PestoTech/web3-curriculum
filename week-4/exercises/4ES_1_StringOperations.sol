// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title StringOperations
 * Contract to perform String Operations
 *
 * 1. Find the length of the given string
 * 2. Find the index of the first occurrence of the given character
 * 3. Replace every occurrence of the given character
 *
 */

contract StringOperations {

    function findLength(string memory s) public pure returns (uint256) {
        return bytes(s).length;
    }

    function findAtIndex(string calldata s, uint256 i) public pure returns (bytes1 ) {
        return bytes(s)[i];
    }

    function replaceAllOccurence(string calldata s, string calldata x, string calldata y ) public pure returns(string memory) {
        bytes memory tmp =  bytes(s);
        for( uint8 i = 0; i< tmp.length; i++ ){
            if(tmp[i] == bytes1(bytes(x))) {
                tmp[i] = bytes1(bytes(y));
            }
        }
        return string(tmp);
    }
}