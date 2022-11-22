/**
 * SPDX License Identifier
 * Trust in smart contracts can be better established if their source code is available. 
 * Since making source code available always touches on legal problems with regards to copyright,
 * the Solidity compiler encourages the use of machine-readable SPDX license identifiers (https://spdx.org/licenses/).
 * Every source file should start with a comment indicating its license.
 *
 * Compiler does include the supplied license string in the bytecode metadata.
 */

// SPDX-License-Identifier: GPL-3.0

/**
 * Pragmas
 * The pragma keyword is used to enable certain compiler features or checks.
 * A pragma directive is always local to a source file, so you have to add the pragma to all your files
 * if you want to enable it in your whole project.
 *
 * Types of pragmas: Version, ABI Coder, and Experimental 
 */

pragma solidity >=0.7.0 <0.9.0;

/**
 * Importing other source files using import statements
 */

/**
 * Comments
 * Single-line comments using '//'
 * Multi-line comments using the same structure we are already part of
 */

/**
 * Contract
 * Smart contract logic that enables the state of the assets to be managed.
 */

/**
 * @title HelloWorld
 * @dev Store & retrieve a string value in a variable
 * @custom:dev-run-script <script to run on successful compilation>
 */
contract HelloWorld {

    string message;

    /**
     * @dev Store string value in variable
     * @param helloMsg value to store
     */
    function store(string memory helloMsg) public {
        message = helloMsg;
    }

    /**
     * @dev Return value 
     * @return value of 'message'
     */
    function retrieve() public view returns (string memory){
        return message;
    }
}