// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/**
 * Reusing Baby contracts
 *
 * creating a Panic in SuperBaby contract to signify not implemented for demo only
 */
interface Baby {
    enum Type {RegularBaby, BossBaby, SuperBaby}
    
    // virtual by default
    function name() external returns (string memory);
    function walkingAndTalking() external returns (string memory);
    function mission() external returns (string memory);
}

/**
 * RegularBaby contract
 */
contract RegularBaby is Baby {

    string public name;
    Type babyType = Baby.Type.RegularBaby;

    constructor(string memory _name) {
        name = _name;
    }
    
    function walkingAndTalking() external view returns (string memory) {
        string memory tempStr = string.concat(name, ", can walk and talk only after 6 months..");
        return tempStr;
    }

    function mission() external view returns (string memory) {
        string memory tempStr = string.concat(name, ", is stealing love meant for elder brother :|");
        return tempStr;
    }
}

/**
 * BossBaby contract
 */
contract BossBaby is Baby {

    string public name;
    Type babyType = Baby.Type.BossBaby;

    // Enable BossBaby to accept ETH on creation by making constructor 'payable'
    // To use in the mission...
    constructor(string memory _name) payable {
        name = _name;
    }

    function walkingAndTalking() external view returns (string memory) {
        string memory tempStr = string.concat(name, ", can walk and talk only after 6 months..");
        return tempStr;
    }

    function mission() external view returns (string memory) {
        string memory tempStr = string.concat(name, ", is stealing love meant for elder brother :|");
        return tempStr;
    }
}

/**
 * SuperBaby contract
 * Throws an assert in constructor to signify not implemented.
 */
contract SuperBaby is Baby {

    string public name;
    Type babyType = Baby.Type.SuperBaby;

    constructor(string memory _name) {
        assert(false);
    }

    function walkingAndTalking() external pure returns (string memory) {
        string memory tempStr = string.concat("Not Designed");
        return tempStr;
    }

    function mission() external pure returns (string memory) {
        string memory tempStr = string.concat("Not Designed");
        return tempStr;
    }
}