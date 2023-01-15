// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract A {
    uint x;
    constructor(uint x_) { x = x_; }
}

// Either directly specify in the inheritance list...
// Fixed at compile time
contract B is A(7) {
    constructor() {}
}

// or through a "modifier" of the derived constructor...
// Can be set during deployment of C
contract C is A {
    constructor(uint y) A(y * y) {}
}


// no arguments passed since A's constructor argument is passed in inheritance list of B
contract D is A, B {
    constructor() {}
}

// otherwise..like so
contract E is A, C {
    constructor() C(10+10) {}
}