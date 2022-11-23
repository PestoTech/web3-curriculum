# Week 4: Mastering Smart Contracts
    Section 2: Special Functions

*How to run the smart contract programs?*
Load the files into remix.ethereum.org and deploy the contracts to run them

This repo contains the following examples:

1. StringEquality (using keccak256 hash function)
2. Understanding Function selectors
3. Understanding ABI Encoding & Decoding
4. Understanding ABI Encoding for function calls

Common Errors:
1. 2_3_ABIEncodingDecoding.sol : uses encode and decode functions. 
    abiDecode function needs to have the input data in particular format otherwise the executin can fail.
    Hence use the output from abiEncode3 function as input to abiDecode function

References:
1. https://docs.soliditylang.org/en/v0.8.17/abi-spec.html?highlight=Selector#formal-specification-of-the-encoding