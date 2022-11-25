// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title Employee
 * Contract with state variables employeeID and employeeName and setter functions
 */
contract Employee {
    uint public employeeID;
    string public employeeName;

    /**
     * @dev setEmployeeID
     * @param _eid value to store
     * @return _eid input value back
     */
    function setEmployeeID(uint _eid) public returns (uint) {
        employeeID = _eid;
        return employeeID;
    }

    /**
     * @dev setEmployeeName
     * @param _name value to store
     * @return _name input value and Employee Contract balance back
     * also accepts ether
     */
    function setEmployeeName(string memory _name) public payable returns (string memory, uint value) {
        employeeName = _name;
        return (employeeName, address(this).balance );
    }
}