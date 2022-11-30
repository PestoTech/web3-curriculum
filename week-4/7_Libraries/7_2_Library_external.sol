// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @dev Search library
 */
library Search {

    function indexOf(uint[] storage self, uint value) public view returns (uint) {
        for (uint i = 0; i < self.length; i++)
            if (self[i] == value) return i;
        return type(uint).max;
    }
}

/**
 * @dev Searches for the uint value and if it is present, updates it with the new value
 */
contract ReplaceContract {
    using Search for uint[];
    uint[] data;

    function append(uint value) public {
        data.push(value);
    }

    function replace(uint from, uint to) public {
        // This performs the library function call externally
        uint index = data.indexOf(from);
        if (index == type(uint).max)
            data.push(to);
        else
            data[index] = to;
    }

    function getData() public view returns (uint[] memory) {
        return data;
    }
}