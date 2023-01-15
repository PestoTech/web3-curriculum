// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Student
 * Contract to demo call and delegate call
 */
contract Student {

    uint public cumulativeScore;
    address public studentAddress;
    
    /**
     * @dev addUsingCall
     * @param calculator address of calculator contract to demo call
     * @param theoryScore a score
     * @param practicalScore another score
     * @return cumulitive score
     *
     * Check the values of cumulativeScore, studentAddress after call execution.
     * The values are the original default values
     */
    function addUsingCall(address calculator, uint theoryScore, uint practicalScore) public returns (uint)  {
        // Uses 'call' to call the add function in calculator
        (bool success, bytes memory result) = calculator.call(abi.encodeWithSignature("add(uint256,uint256)", theoryScore, practicalScore));
        require(success, "The call to calculator contract failed");
        return abi.decode(result, (uint));
    }

    /**
     * @dev addUsingDelegateCall
     * @param calculator address of calculator contract to demo call
     * @param theoryScore a score
     * @param practicalScore another score
     * @return cumulitive score
     *
     * Check the values of cumulativeScore, studentAddress after call execution.
     * The values have changed to the values of the execution, but the state of calculator contract has not changed
     */
    function addUsingDelegateCall(address calculator, uint theoryScore, uint practicalScore) public returns (uint)  {
        // Uses 'delegatecall' to call the add function in calculator
        (bool success, bytes memory result) = calculator.delegatecall(abi.encodeWithSignature("add(uint256,uint256)", theoryScore, practicalScore));
        require(success, "The call to calculator contract failed");
        return abi.decode(result, (uint));
    }
}

pragma solidity ^0.8.17;

/**
 * @title Calculator
 * Monitor the state of the variables after the function calls
 */
contract Calculator {
    uint public result;
    address public user;
    
    function add(uint a, uint b) public returns (uint) {
        result = a + b;
        user = msg.sender;
        return result;
    }
}