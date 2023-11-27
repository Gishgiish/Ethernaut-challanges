// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TakeMyMoney {
    constructor() payable {}

    function takeMyMoney(address _forceContract) public {
        selfdestruct(payable(_forceContract));
    }
}
