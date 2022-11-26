// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./9_1_BabyContracts.sol";

// error can be defined outside or inside of contracts
error ShortBabyNameError(string name, uint256 size);

/**
 * @title SafeBabyFactory
 * Creates new babies based on Type input and maintains a list
 */
contract SafeBabyFactory {
    
    Baby[] public babies;

    event NewBaby(address babyAddress, uint256 missionMoney, string);

    function createBaby(string memory babyName, Baby.Type babyType) external payable returns (bool) {

        // using require to demo the creation of Error(string) predefind error
        require(bytes(babyName).length > 0,"Babies MUST HAVE NAME");

        // To demo use of custom error : ShortBabyNameError
        if(bytes(babyName).length < 2) {
            revert ShortBabyNameError({name: babyName, size: bytes(babyName).length});
        }

        Baby tmpBaby;

        if (babyType == Baby.Type.RegularBaby) {
            
            tmpBaby = new RegularBaby(babyName);
        } else if (babyType == Baby.Type.BossBaby){
            // sending ETH to BossBaby on creation
            tmpBaby = new BossBaby{value: msg.value}(babyName);
        } else {
            // to demo failure during contract creation
            tmpBaby = new SuperBaby(babyName);
        }

        babies.push(tmpBaby); //Pushing the baby to the array only...:P

        string memory emitString = string.concat("New Baby..", tmpBaby.name() );

        emit NewBaby(address(tmpBaby), address(tmpBaby).balance, emitString);

        return true;
    }
}