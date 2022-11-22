// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * Observe that Employee Interface is being defined here. 
 * Important to note how the interface to a contract can be defined on demand.
 * Alternatively one can define the same interface is a different file and import that here aswell.
 */

interface Employee {
    function setEmployeeID(uint _eid) external returns (uint);
    function setEmployeeName(string memory _name) external payable returns (string memory, uint value);
}

/**
 * @title Office
 * Contract with to set state variables employeeID and employeeName in the deployed emp contract.
 */
contract Office {

    /**
     * @dev setEID
     * @param _emp address of the employee contract
     * @param _eid value to store
     */
    function setEID(Employee _emp, uint _eid) public {
        _emp.setEmployeeID(_eid);
    }

    /**
     * @dev setNameandSendEther : sets name and forwards ether to calling function
     * @param _emp address of the employee contract
     * @param _name value to store
     */
    function setNameandSendEther(Employee _emp, string memory _name) public payable {
        (string memory x, uint value) = _emp.setEmployeeName{value: msg.value} ( _name );
    }
}