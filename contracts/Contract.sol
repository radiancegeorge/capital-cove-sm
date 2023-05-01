// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "./Utils.sol";
import "@ganache/console.log/console.sol";

contract GenerateCoupon is Utils {
    event PayForPlan(bytes32 email, uint8 plan);
    event Payout(address _address, uint8 _plan);

    modifier limitPlan(uint8 _planId) {
        require(
            _planId <= planLimit,
            "id is greater than allowed number of plans"
        );
        _;
    }

    function ngnToUsd(uint _value) private view returns (uint) {
        return _value / USDNGN;
    }

    function payForPlan(bytes32 _email, uint8 _plan) public {
        //price is always in ngn
        uint price = Plans[_plan].price;

        require(
            USDT.allowance(msg.sender, address(this)) >= ngnToUsd(price),
            "Adequate allowance not given"
        );
        USDT.transferFrom(msg.sender, address(this), ngnToUsd(price));
        emit PayForPlan(_email, _plan);
    }

    function payout(address _address, uint8 _plan) public isOwner {
        uint price = Plans[_plan].price;
        uint value = (price * earnPercentage) / 100;
        USDT.transferFrom(address(this), _address, ngnToUsd(value));
    }

    function createPlan(
        uint8 _planId,
        bytes32 _name,
        uint256 _price
    ) public isOwner {
        Plans[_planId].price = _price;
        Plans[_planId].name = _name;
    }

    function getPlans() public view returns (Plan[] memory) {
        Plan[] memory allPlans;
        for (uint8 x = 1; x < planLimit; x++) {
            if (Plans[x].name != "") {
                allPlans[x] = Plans[x];
            }
        }

        return allPlans;
    }

    function getSinglePlan(
        uint8 _planId
    ) public view limitPlan(_planId) returns (Plan memory) {
        return Plans[_planId];
    }

    function withdraw(address _address, uint256 _value) public isOwner {
        USDT.transferFrom(address(this), _address, _value);
    }
}
