// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract A {

    // foo is marked virtual
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

// Contracts inherit other contracts by using the keyword 'is'. 
// Single Inheritance
contract B is A {
    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

// Single Inheritance
contract C is A {
    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in
// different contracts, parent contracts are searched from
// right to left, and in depth-first manner.

//Multiple Inheritance
contract D is B, C {
    // D.foo() returns "C"
    // since C is the right most parent contract with function foo()
    function foo() public pure override(B, C) returns (string memory) {
        
        /**
         * further custome logic can go here
         */

        return super.foo();
    }
}

//Multiple Inheritance
contract E is C, B {
    // E.foo() returns "B"
    // since B is the right most parent contract with function foo()
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo();
        
        //One can call an explicit implementation using the contract name like so,
        // return C.foo();
        // This is allowed as well.
    }
}

// Inheritance must be ordered from “most base-like” to “most derived”.
// Swapping the order of A and C will throw a compilation error.
//Multipath Inheritance
contract F is A, C {
    
    function foo() public pure override(A, C) returns (string memory) {
        return super.foo();
    }
}