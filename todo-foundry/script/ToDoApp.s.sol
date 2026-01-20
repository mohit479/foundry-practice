// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {TodoApp} from "../src/TodoApp.sol";

contract ToDoAppScript is Script{
    function run()public{
        vm.startBroadcast();
        new TodoApp();
        vm.stopBroadcast();
    }

}