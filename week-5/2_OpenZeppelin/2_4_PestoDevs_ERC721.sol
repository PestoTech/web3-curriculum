// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master//contracts/token/ERC721/ERC721.sol";

contract PestoDevsNFT is ERC721 {
    constructor() ERC721("PestoDevs", "PD") {
        // mint an NFT to yourself
        _mint(msg.sender, 1);
    }
}
