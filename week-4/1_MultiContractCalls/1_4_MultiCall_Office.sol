// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title Office
 * Contract with to set state variables employeeID and employeeName in the deployed emp contract.
 *
 * Note: One can use the address of the already deployed Employee contract from previous example
 * or deploy a new instance and use the new address of Employee contract.
 */
contract Office {

    event Response(bool status, bytes data );

    /**
     * @dev setEID sets the employeeID on the employee contract
     * @param _emp address of the employee contract
     * @param _eid value to store
     */
    function setEID(address _emp, uint _eid) public {

        // ABI encoding the calling function signature and it parameters
        bytes memory encodedFunSig = abi.encodeWithSignature("setEmployeeID(uint256)", _eid);
        
        (bool success, bytes memory data) = _emp.call(encodedFunSig);

        emit Response(success, data);
    }

    /**
     * @dev setNameandSendEther : sets name and forwards ether to setEmployeeName on employee contract
     * @param _emp address of the employee contract
     * @param _name value to store
     */
    function setNameandSendEther(address _emp, string memory _name) public payable {

        // ABI encoding the calling function signature and it parameters
        bytes memory encodedFunSig = abi.encodeWithSignature("setEmployeeName(string)", _name);
        
        (bool success, bytes memory data) = _emp.call{value: msg.value}(encodedFunSig);

        emit Response(success, data);
    }
}