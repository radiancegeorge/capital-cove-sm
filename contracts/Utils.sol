// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./Storage.sol";

contract Utils is Storage {
    modifier isOwner() {
        require(
            msg.sender == owner,
            "You do not have the permision to call these function"
        );
        _;
    }

    function transfer(address _address) public isOwner {
        owner = _address;
    }

    function setUSDNGNRate(uint256 _value) public isOwner {
        USDNGN = _value;
    }

    function setUsdtTokenAddress(address _address) public isOwner {
        USDT = ERC20Token(_address);
    }

    function setEarnPercentage(uint8 _value) public isOwner {
        earnPercentage = _value;
    }

    function setPlanLimit(uint8 _value) public isOwner {
        planLimit = _value;
    }
}
