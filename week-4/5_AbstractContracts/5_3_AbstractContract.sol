// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Abstract Contract sample by marking constructor internal
abstract contract A {
    uint x;
    constructor(uint x_) internal { x = x_; }
}


contract B is A {
    constructor(uint x_) A(x_) {

    }
}