// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./9_2_SafeBabyFactory.sol";

/**
 * To demo SafeBabyFactory 
 */
contract DemoSafeBabyFactory {

    event Log(bool success, string logInfo);
    event LogBytes(bool success, bytes logInfo);
    
    function createBaby(address factoryAddress, string memory babyName, Baby.Type babyType) external payable {

        try SafeBabyFactory(factoryAddress).createBaby{value: msg.value}(babyName,babyType) returns (bool status) {
            if(status) {
                emit Log(status, "Baby Created Safely"); 
            }
        }catch Error(string memory reason) {
            // This is executed in case
            // require was called for empty name string
            emit Log(false, reason);
        } catch Panic(uint errorCode) {
            // This is executed in case of a panic,
            // i.e. the creation of SuperBaby
            emit Log(false, "Did you create a SuperBaby");
        } catch (bytes memory data) {
            // This is executed in case of revert custom error.
            emit LogBytes(false, data);
        } 
    }
}