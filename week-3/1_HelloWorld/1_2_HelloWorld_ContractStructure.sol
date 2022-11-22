// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title HelloWorld
 * @dev Store & retrieve a string value in a variable
 * @custom:dev-run-script <script to run on successful compilation>
 *
 * The 'contract' keyword followed by its name and the logic of the contract representing the smart contract.
 * Uses the curly-braces style of programming.
 * Among the various types of solidity contracts strctures supported, this contract only has,
 * state variables and functions
 */
contract HelloWorld {

    /**
     * State variables, define the state of the contract.
     * State of the contract as defined by the state vaiables, 
     * can be changed by the rules defined in the functions only.
     *
     * Stored permanently in the contract state.
     */
    string message;

    /**
     * @dev Store string value in variable
     * @param helloMsg value to store
     *
     * A function has the rules or logic based on which the state of the contract can be changed.
     * This is the only way how the value of the state variables in contract can be changed (for now !!).
     * 
     * A function that takes a parameter and returns nothing.
     * Ignore 'memory' keyword for now.
     *
     */
    function store(string memory helloMsg) public {
        message = helloMsg;
    }

    /**
     * @dev Return value 
     * @return value of 'message'
     *
     * A function that does not take any parameters and returns a string.
     * Again, ignore 'memory' & 'view' keywords for now.
     *
     */
    function retrieve() public view returns (string memory) {
        return message;
    }
}