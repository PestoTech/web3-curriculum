// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * Observe that Employee Interface is being defined here. 
 * Important to note how the interface to a contract can be defined on demand.
 * Alternatively one can define the same interface is a different file and import that here aswell.
 *
 * Note: One can use the address of the already deployed Employee contract from previous example
 * or deploy a new instance and use the new address of Employee contract.
 */

interface Employee {

    enum EmployeeType {INTERN, PERMANENT, CONTRACT}
    
    struct EmployeeName {
        string firtstName;
        string middleName;
        string lastName;
    }
    
    function setEmployeeID(uint _eid) external returns (uint);
    function setEmployeeName(string memory _name) external payable returns (string memory, uint value);
}

/**
 * @title Office
 * Contract with to set state variables employeeID and employeeName in the deployed emp contract.
 */
contract Office {

    /**
     * @dev setEID sets the employeeID on the employee contract
     * @param _emp address of the employee contract
     * @param _eid value to store
     */
    function setEID(Employee _emp, uint _eid) public {
        _emp.setEmployeeID(_eid);
    }

    /**
     * @dev setNameandSendEther : sets name and forwards ether to setEmployeeName on employee contract
     * @param _emp address of the employee contract
     * @param _name value to store
     */
    function setNameandSendEther(Employee _emp, string memory _name) public payable {
        (string memory x, uint value) = _emp.setEmployeeName{value: msg.value} ( _name );
    }
}