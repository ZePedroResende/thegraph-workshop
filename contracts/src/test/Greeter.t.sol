// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {Greeter} from "../Greeter.sol";
import {DSTestPlus} from "./utils/DSTestPlus.sol";

contract GreeterTest is DSTestPlus {
    Greeter greeter;

    function setUp() public {
        console.log("Testing Greeter.sol...");
        greeter = new Greeter("Hi fren!");
    }

    function testSeGreeting() public {
        greeter.setGreeting("GM fren!");
        assertEq(greeter.greet() ,"GM fren!");
        console.log(unicode"✅ setgreeting() test passed");
    }
}
