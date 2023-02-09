// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract TokenSaleV2 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    IERC20 public token;
    uint256 public pricePerEth;

    event TokenSold(
        address indexed buyer,
        address indexed seller,
        uint256 indexed saleCount
    );

    function initialize(
        address _token,
        uint256 _pricePerEth
    ) public initializer {
        //Calling the OwnableUpgradeable's initializer function
        __Ownable_init();
        __UUPSUpgradeable_init();

        // Making some initializations
        token = IERC20(_token);
        pricePerEth = _pricePerEth;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function buyTokens() external payable {
        require(msg.value >= 100000000000000000 wei, "Required Ether not sent");

        uint256 saleCount = msg.value * pricePerEth;
        require(
            saleCount <= token.allowance(owner(), address(this)),
            "Insufficient allowance"
        );

        require(
            token.transferFrom(owner(), msg.sender, saleCount),
            "Transfer Failed"
        );

        emit TokenSold(msg.sender, address(this), saleCount);
    }

    function withdraw() external onlyOwner {
        (bool status, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(status, "Withdrawal failed");
    }
}
