// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./8_1_BabyContracts.sol";

/**
 * Purpose: To calculate address of the contract before deployment
 */
contract BabyFactory {
    Baby[] public babies;

    event NewBaby(address babyAddress, uint256 missionMoney, string);

    // Check the new of new keyword
    // Note: _salt needs to be a byte32 (just pick a 32 byte tx hash or block hash)
    // example: 0xaa6ddee94af698c0709c9dd10eacba695d011fd0bc92b85a3c6a0372e273a2db
    function createBaby(string memory babyName, Baby.Type babyType, bytes32 _salt) external payable {
        Baby tmpBaby;

        if (babyType == Baby.Type.RegularBaby) {
            
            // passing salt value to new
            tmpBaby = new RegularBaby{salt: _salt}(babyName);
        } else if (babyType == Baby.Type.BossBaby){
            // sending ETH and salt value to contract creation
            tmpBaby = new BossBaby{value: msg.value, salt: _salt}(babyName);
        } else {
            revert("SuperBaby is yet to be designed..");
        }

        babies.push(tmpBaby); //Pushing the baby to the array only...:P

        string memory emitString = string.concat("New Baby..", tmpBaby.name() );

        emit NewBaby(address(tmpBaby), address(tmpBaby).balance, emitString);
    }

    // Get bytecode of contract to be deployed
    // NOTE: babyName is argument of the Baby contract constructors
    function getContractBytecode(string memory babyName, Baby.Type babyType) public pure returns (bytes memory) {

        bytes memory bytecode;
        
        if (babyType == Baby.Type.RegularBaby) {
            bytecode = type(RegularBaby).creationCode;
        } else if (babyType == Baby.Type.BossBaby){
            bytecode = type(BossBaby).creationCode;
        } else {
            revert("SuperBaby is yet to be designed..");
        }
        return abi.encodePacked(bytecode, abi.encode(babyName));
    }

    // compute the address given the same set of inputs and salt to constructor
    // Note: _salt needs to be a byte32 (just pick a 32 byte tx hash or block hash)
    // example: 0xaa6ddee94af698c0709c9dd10eacba695d011fd0bc92b85a3c6a0372e273a2db
    function computeAddress(string memory babyName, Baby.Type babyType, bytes32 _salt) external view returns (address) {
        
        bytes memory bytecode = getContractBytecode(babyName, babyType);

        // This complicated expression just tells you how the address
        // can be pre-computed. It is just there for validation only
        address computedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            _salt,
            keccak256(bytecode)
            )))));

        return computedAddress;
    } 
}