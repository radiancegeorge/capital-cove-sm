// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(uint256 _innitialSupply) ERC20("Token", "T") {
        _mint(msg.sender, _innitialSupply);
    }
}
