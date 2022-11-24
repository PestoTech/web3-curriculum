// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract A {

    // marked virtual to enable overriding
    modifier foo() virtual {
        // custom logic goes here..
        _;
        // custom logic can also go here..
    }
}

contract B {

    // marked virtual to enable overriding
    modifier foo() virtual {_;}
}

//Simple Inheritance
contract C is B {

    // marked override to signify overriding
    // not marked virtual, hence cannot be overridden
    modifier foo() override {_;}
}

//Multiple Inheritance
contract D is A, B
{
    // marked override to signify overriding
    modifier foo() override(A, B) {_;}
}