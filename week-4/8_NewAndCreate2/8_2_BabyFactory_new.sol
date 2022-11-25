// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/**
 * Another style of importing multiple contracts from a file
 * import "./8_1_BabyContracts.sol" works just fine.
 * 
 * Also note the usage of Baby as IBaby (specifying an alias name)
 */
import {Baby as IBaby, RegularBaby, BossBaby} from "./8_1_BabyContracts.sol";

/**
 * Creates new babies based on Type input and maintains a list
 */
contract BabyFactory {
    
    IBaby[] public babies;

    event NewBaby(address babyAddress, uint256 missionMoney, string);

    // Check the use of new keyword
    function createBaby(string memory babyName, IBaby.Type babyType) external payable {
        IBaby tmpBaby;

        if (babyType == IBaby.Type.RegularBaby) {
            
            tmpBaby = new RegularBaby(babyName);
        } else if (babyType == IBaby.Type.BossBaby){
            // sending ETH to BossBaby on creation
            tmpBaby = new BossBaby{value: msg.value}(babyName);
        } else {
            revert("SuperBaby is yet to be designed..");
        }

        babies.push(tmpBaby); //Pushing the baby to the array only...:P

        string memory emitString = string.concat("New Baby..", tmpBaby.name() );

        emit NewBaby(address(tmpBaby), address(tmpBaby).balance, emitString);
    }

    /*
    * An exercise to return all the baby details given the index of the array.
    * name, type, walkingAndTalking, mission.
    *
    * Make all the necessary changes, but do not break the existing functionality.
    */
}