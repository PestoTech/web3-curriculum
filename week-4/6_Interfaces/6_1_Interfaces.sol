// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

// interface sample for Animal
interface Animal {
    // virtual by default
    function movement() external returns (string memory);
}

interface SuperAnimal is Animal {
    // virtual by default
    function voice() external returns (string memory);
}

// Not implementing interface function 'movement', hence abstract
abstract contract Snail is Animal {
    function voice() external pure returns (string memory) {
        return "may be...naah..";
    }
}

// Inheriting multiple interfaces
// Remember 'TURBO' from the animation movie, a snail with superpowers... 
contract TURBO is SuperAnimal {
    // Implementing interface function 'movement'
    function movement() public pure returns (string memory){
        return 'Race with light speed...';
    }

    function voice() public pure returns (string memory){
        return 'It talks, in mexican accent !!';
    }
}