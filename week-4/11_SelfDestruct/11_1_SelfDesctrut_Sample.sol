// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// A simple contract that does not have receive function
contract HelloWorld{
    
    string public mesg;
    
    function setMsg(string memory message) public {
        mesg=message;
    }

    // fucntion to get contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

// Sink contract that can accept funds and can be destructed.
contract Sink{
    function fundMe() public payable  {
        //Doing nothing other than receiving ETH
    }
    
    //call selfdestruct with the HelloWorld contract address
    function destroy(address someAddress) public {
        selfdestruct(payable(someAddress));
    }
}