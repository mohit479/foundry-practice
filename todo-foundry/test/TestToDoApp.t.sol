// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {TodoApp} from "../src/TodoApp.sol";

contract TestToDoApp  is Test{
    TodoApp todo;
    address owner= makeAddr("owner");

    function SetUp()public{
        todo= new TodoApp();
        owner=msg.sender;
    }

    function TestOwner() public{
        assertEq(todo.i_owner,owner);
    }

    // function Test
}