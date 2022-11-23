// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title SampleCode
 * Contract to demo ABI encoding & decoding.
 */
contract SampleCode {

    /**
     * @dev abiEncode1
     * @param num to encode
     * @return abiEncoded num in hexadecimal byte array
     * Example: 15
     * Returns: 0x000000000000000000000000000000000000000000000000000000000000000f (32 bytes)
     */
    function abiEncode1(uint num ) public pure returns (bytes memory) {
        return abi.encode(num);
    }

    /**
     * @dev abiEncode2
     * @param numbers to encode
     * @return abiEncoded numbers
     * Example: [10, 12, 13]
     * Returns:
     * [0]: 0x0000000000000000000000000000000000000000000000000000000000000020 (offset to start of data)
     * [1]: 0x0000000000000000000000000000000000000000000000000000000000000003 (length of the data)
     * [2]: 0x000000000000000000000000000000000000000000000000000000000000000a (decimal 10)
     * [3]: 0x000000000000000000000000000000000000000000000000000000000000000c (decimal 12)
     * [4]: 0x000000000000000000000000000000000000000000000000000000000000000d (decimal 13)
     */
    function abiEncode2(uint[] memory numbers ) public pure returns (bytes memory) {
        return abi.encode(numbers);
    }

    struct sample {
        bool status;
        uint256 num;
        bytes20 anAddress;
    }

    /**
     * @dev abiEncode3
     * @return abiEncoded struct sample
     *
     */
    function abiEncode3( ) public view returns (bytes memory) {

        // creating a value for sample type
        // Third parameter will be your address executing the function
        sample memory s = sample(true,156, bytes20(msg.sender));
        return abi.encode(s);
    }

    /**
     * @dev abiDecode
     * @param data ,byte array output from running abiEncode3
     * @return constituents of the sample struct
     * Example: 0x0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000009c5b38da6a701c568545dcfcb03fcb875f56beddc4000000000000000000000000
     *
     */
    function abiDecode(bytes memory data) public pure returns (bool, uint256, bytes20) {
        // See how the sample type is broken to its constitute types and passed as info for decoding
        return abi.decode(data, (bool, uint256, bytes20));
    }

}