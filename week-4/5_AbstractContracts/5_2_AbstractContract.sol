// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract A {
    uint x;
    constructor(uint x_) { x = x_; }
}

// Abstract Contract sample by not calling the base call constructor with arguments
// declare abstract...
abstract contract B is A {
    constructor(uint x_) {

    }
}

// or have the next concrete derived contract initialize it.
contract C is B {
    constructor(uint x_) A(x_ + x_) B(x_) {

    }
}