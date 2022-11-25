// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

// Observe that Employee file is being imported here.
import "./1_1_MultiCall_Employee.sol";

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