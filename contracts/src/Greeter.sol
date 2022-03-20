// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

contract Greeter {
    string private _greeting;

    constructor(string memory initGreeting) {
        _greeting = initGreeting;
    }

    function greet() external view returns (string memory) {
        return _greeting;
    }

    function setGreeting(string calldata newGreeting) external {
        _greeting = newGreeting;
    }
}
