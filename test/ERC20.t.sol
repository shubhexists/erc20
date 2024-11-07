// SPDX-License-Identifier: UN
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";

contract Shubh is ERC20 {
   
}


contract ShubhTest is Test {
    Shubh public token;
    address public owner = address(1);
    address public user = address(2);

    function setUpToken() public {
        token = new Shubh("Shubh", "SH", 18);
    }
}
