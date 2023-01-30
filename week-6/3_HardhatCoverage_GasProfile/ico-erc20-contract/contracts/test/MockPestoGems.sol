pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

// MockPestoGems is an mock contract for testing
contract MockPestoGems is IERC20, IERC20Metadata {
    constructor(uint256 _initalSupply) {}

    function totalSupply() external view returns (uint256) {
        return 1 * (10 ** 6) * (10 ** 18);
    }

    function balanceOf(address account) external view returns (uint256) {
        return 0;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {
        return 0;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        return true;
    }

    function name() external view returns (string memory) {
        return "MyPestoGems";
    }

    function symbol() external view returns (string memory) {
        return "MPG";
    }

    function decimals() external view returns (uint8) {
        return 18;
    }
}
