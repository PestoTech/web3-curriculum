// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Example {
    function demo() public {
        uint16 a = 1000;
        uint8 b = 2;
        int16 c = -1;
        uint32 d = 120000;
        address e = 0xEe5F5c53CE2159fC6DD4b0571E86a4A390D04846;
        uint160 s;
        
        //allowed
        a = 100;
        console.log(a);   //Output: 100
        a = 0xab;
        console.log(a);   //Output: 171
        a = b;      // Implicit Coversion
        console.log(a);   //Output: 2

        // Allowed via Explicit Conversion
        a = uint16(c);
        console.log(a);     //Output: 65535 
        a = uint16(d);      
        console.log(a);     //Output: 54464
        s = uint160(e);     
        console.log(s);     //Output: 1360866417097670530408485081821726439532936579142
        
        // Not allowed

        //TypeError: Type int_const 300 is not implicitly convertible to expected type uint8.
        //Literal is too large to fit in uint8
        // a = 300000;   error

        // TypeError: Type literal_string "0xab" is not implicitly convertible to expected type uint8
        // a = '0xab';   error

        //TypeError: Type int16 is not implicitly convertible to expected type uint16. Loss of sign
        // a = c;   error

        //TypeError: Type uint32 is not implicitly convertible to expected type uint16.
        // a = d;  error
    }
} 