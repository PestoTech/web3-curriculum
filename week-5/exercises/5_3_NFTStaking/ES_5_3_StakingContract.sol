 // SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol";
import "./ES_5_3_RewardToken.sol";

contract StakingContract is IERC721Receiver {

    struct StakeInfo {
        address staker;
        address collection;
        uint256 time;
        uint256 tokenId;
    }

    RewardToken rToken;
    uint256 rewardPer1Min = 1;
    mapping(address=> StakeInfo[]) public staked;

    constructor() {
        rToken = new RewardToken("StakingReward","SRNFT");
    }

    function stakeNFT(address collection, uint256 tokenId) external {
        require(collection != address(0), "Invalid Collection");

        staked[msg.sender].push( StakeInfo(msg.sender, collection, block.timestamp, tokenId));

        IERC721(collection).transferFrom(msg.sender,address(this), tokenId);

    }

    function unStake(address collection, uint256 tokenId) external {
        StakeInfo[] storage userStakes =  staked[msg.sender];
        uint256 stakeIndex;
        bool found;
        
        for(uint256 i = 0; i < userStakes.length; i++ ) {
            if(collection == userStakes[i].collection ){
                if(tokenId == userStakes[i].tokenId) {
                    found = true;
                    stakeIndex = i;
                }
            }
        }

        require(found, "Invalid collection or token id");

        uint256 rewardAmount = calculateReward(userStakes[stakeIndex]);
        delete userStakes[stakeIndex];
        rToken.mint(msg.sender, rewardAmount);
        IERC721(collection).transferFrom(address(this), msg.sender, tokenId);

    }

    function calculateReward(StakeInfo memory stakeInfo) public view returns(uint256) {
        uint256 currentTime = block.timestamp;
        uint256 diff = currentTime = stakeInfo.time;
        return (diff/60) * rewardPer1Min * rToken.decimals(); 
    }

    function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }   
}