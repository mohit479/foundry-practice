// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {TodoApp} from "../src/TodoApp.sol";

contract TestToDoApp  is Test{
    TodoApp todo;
    address owner= makeAddr("owner");
    address USER = makeAddr("User");

    function setUp()public{
        vm.prank(owner);
        todo= new TodoApp();

        vm.deal(USER, 10 ether);
    }  

    function testOwner() public{
        assertEq(todo.getOwner(),owner);
    }

    function testCreateSingleTask()public{
        uint oldIndex = todo.getIndex();

        vm.prank(USER);
        todo.createtask("learn foundry");

        (uint id ,string memory title ,bool compleated )= todo.getTask(USER, 0);

        assertEq(id,1);
        assertEq(title, "learn foundry");
        assertEq(compleated, false);
        assertEq(todo.getIndex(),oldIndex+1);
        assertEq(todo.getIsRegistered(USER), true);
        assertEq(todo.getListOwnerId(1),USER);
    }

    function testMultipalTaskCreatedSingleUser()public{

        for(uint i =1; i<10 ;i++){
            address addr = address(uint160(i));
            vm.deal(addr,1 ether);
            vm.prank(addr);
            todo.createtask("new task created");

            //REMAINING
        }
    }
}