// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract MarbleExcahnge {

    struct Listing {
        address seller;
        uint256 numMarbles;
        uint256 priceInWei;
    }

    IERC20 immutable _marbles;

    mapping(address => Listing) public sellerListings;
    address[] public allSellers;

    error ZeroAmount();
    error MintOnceOnly();
    
    // Note the call of constructors from ERC20 and ERC20Capped
    constructor(address marbles) {
        _marbles = IERC20(marbles);
    }

    // considering the same function for both add and update
    function addListing(uint256 count, uint256 priceInWei) external {
        if(sellerListings[msg.sender].priceInWei == 0) {
            allSellers.push(msg.sender);
        }

        require(_marbles.balanceOf(msg.sender) >= sellerListings[msg.sender].numMarbles + count,"Not enough marbles to list");

        sellerListings[msg.sender].seller = msg.sender;
        sellerListings[msg.sender].numMarbles += count;
        sellerListings[msg.sender].priceInWei = priceInWei;
    }

    function allListings() external returns(Listing[] memory) {
        Listing[] memory allListings = new Listing[](allSellers.length);
        for(uint256 i =0; i < allSellers.length; i++ ) {
            address seller = allSellers[i];
            allListings[i] = sellerListings[seller];
        }
        return allListings;
    }


    function trade(address seller, uint256 count) external payable {
        Listing memory l = sellerListings[seller];
        require( count <= l.numMarbles, "Not Enough Marbles");
        uint256 requiredETH = l.priceInWei * count;
        require(msg.value >= requiredETH, "Not enough ETH sent");
        uint256 bal;
        if( msg.value > requiredETH) {
            bal = msg.value - requiredETH;
        }
        _marbles.transferFrom(seller, msg.sender, count);
        payable(seller).transfer(requiredETH);
        if(bal > 0) {
            payable(msg.sender).transfer(bal);
        }
    }
}
