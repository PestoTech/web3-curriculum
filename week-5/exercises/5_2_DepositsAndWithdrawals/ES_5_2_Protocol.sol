// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import {ReceiptTokens} from "./ES_5_2_ReceiptTokens.sol";

contract Protocol is Ownable {
    mapping(address => IERC20) public supportedTokens;
    mapping(address => ReceiptTokens) public receiptTokens;

    event Deposit(address benenficiary, address token, uint256 amount);
    event Withdrawal(address benenficiary, address token, uint256 amount);

    modifier isSupported(address _token) {
        require( address(supportedTokens[_token]) != address(0), "Token not supported");
        _;
    }

    constructor(address wBTC) {
        supportedTokens[wBTC] = IERC20(wBTC);
        receiptTokens[wBTC] = new ReceiptTokens(
            wBTC,
            "Receipt Wrapped BTC",
            "rWBTC"
        );
    }

    function deposit(address _token, uint256 amount ) external isSupported(_token) {
        emit Deposit(_msgSender(), _token, amount);
        bool status = IERC20(_token).transferFrom(
            _msgSender(),
            address(this),
            amount
        );
        require(status, "transferFrom failed");
        ReceiptTokens(receiptTokens[_token]).mint(_msgSender(), amount);
    }

    function withdraw( address _token, uint256 amount ) external isSupported(_token) {
        emit Withdrawal(_msgSender(), _token, amount);
        ReceiptTokens(receiptTokens[_token]).burn(_msgSender(), amount);
        bool status = IERC20(_token).transfer(_msgSender(), amount);
        require(status, "transfer failed");
    }
}