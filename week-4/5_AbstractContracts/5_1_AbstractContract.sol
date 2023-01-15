// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

// Abstract Contract sample by not implementing the 'movement' function
abstract contract Animal {
    function movement() public virtual returns (string memory);
}

// Implementation Contract defining the 'movement' function
contract Snake is Animal {
    function movement() public pure override returns (string memory){
        return 'Slithering';
    }
}

// Implementation Contract defining the 'movement' function
contract Snail is Animal {
    function movement() public pure override returns (string memory){
        return 'Creeping';
    }
}