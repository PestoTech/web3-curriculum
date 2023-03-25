// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Example {
    function demo() public {
        uint16 a = 1000;
        uint8 b = 2;
        int16 c = -1;
        uint32 d = 120000;
        
        //allowed
        a = 100;
        a = 0xab;
        a = b;      // Implicit Coversion

        // Not allowed
        //TypeError: Type int_const 300 is not implicitly convertible to expected type uint8.
        //Literal is too large to fit in uint8
        a = 300000;

        // TypeError: Type literal_string "0xab" is not implicitly convertible to expected type uint8
        a = '0xab';

        //TypeError: Type int16 is not implicitly convertible to expected type uint16. Loss of sign
        a = c;

        //TypeError: Type uint32 is not implicitly convertible to expected type uint16.
        a = d;  
    }
}