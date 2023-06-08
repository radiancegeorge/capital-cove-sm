// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

abstract contract ERC20Token {
    function allowance(
        address _owner,
        address _spender
    ) public view virtual returns (uint256 remaining);

    function decimals() public view virtual returns (uint8);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public virtual returns (bool success);

    function transfer(
        address _to,
        uint256 _value
    ) public virtual returns (bool success);
}

contract Storage {
    constructor() {
        owner = msg.sender;
    }

    uint256 public USDNGN;
    address public owner;
    ERC20Token public USDT;
    struct Plan {
        bytes32 name;
        uint price;
    }
    mapping(uint => Plan) public Plans;

    struct PayoutProperties {
        uint16 plan;
        address _address;
    }

    uint8 earnPercentage = 150;
    uint8 planLimit = 5;
}
