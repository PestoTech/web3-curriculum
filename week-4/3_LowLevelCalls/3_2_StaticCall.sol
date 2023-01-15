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
     * @dev addUsingStaticCall
     * @param calculator address of calculator contract to demo call
     * @param theoryScore a score
     * @param practicalScore another score
     * @return cumulitive score
     *
     * Calling this function shall result in failure of the execution as staticcall was used to call 
     * a target function that is changing the contract state.
     * 
     */
    function addUsingStaticCall(address calculator, uint theoryScore, uint practicalScore) public returns (uint)  {
        // Uses 'delegatecall' to call the add function in calculator
        (bool success, bytes memory result) = calculator.staticcall(abi.encodeWithSignature("add(uint256,uint256)", theoryScore, practicalScore));
        require(success, "The call to calculator contract failed");
        return abi.decode(result, (uint));
    }
}

pragma solidity ^0.8.17;

/**
 * @title Calculator
 * Calling the add function changes the state of the contract
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