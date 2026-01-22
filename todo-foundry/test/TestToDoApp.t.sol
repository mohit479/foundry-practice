// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {TodoApp} from "../src/TodoApp.sol";

contract TestToDoApp  is Test{
    TodoApp todo;
    address owner= makeAddr("owner");
    address USER = makeAddr("User");
    address USER2 = makeAddr("User2");



    function setUp()public{
        vm.prank(owner);
        todo= new TodoApp();

        vm.deal(USER, 10 ether);
    }  

  function testOwnerIsTestContractWhenNoPrank() public {
    TodoApp t = new TodoApp();
    assertEq(t.getOwner(), address(this));
}

function testOwnerIsPrankedAddress() public {
    vm.prank(owner);
    TodoApp t = new TodoApp();
    assertEq(t.getOwner(), owner);
}


    function testCreateTaskAddsTaskForCaller()public{
        vm.prank(USER2);
        todo.createtask("test task");

        (uint id ,string memory title , bool compleated)=todo.getTask(USER2,0);
        assertEq(title,"test task");
        assertEq(id, 1);
        assertEq(compleated, false);

    }

    function testCreateTaskIdUnique()public{

        uint [] memory ids;

        for (uint160 i = 0; i < 20; i++) {
            address addr = address(i);
            vm.prank(addr);
            todo.createtask("new task");

            uint task_index = todo.getTaskIndex(USER2);

            for(uint j =0 ;j<ids.length;j++){
                assert(task_index!=ids[j]);
            } 
        }
    }

    function testCreateTaskRegistersUserOnFirstTask() public {
    // Arrange
    address user = makeAddr("user");

    // Act
    vm.prank(user);
    todo.createtask("First Task");

    // Assert
    bool registered = todo.getIsRegistered(user);
    assertTrue(registered);
}


    function testCreateTaskDoesNotReRegisterExistingUser() public {
        vm.prank(USER2);
        todo.createtask("task1");
        uint oldIndex= todo.getIndex();
        address oldUser= todo.getListOwnerId(oldIndex);

        assertTrue(todo.getIsRegistered(USER2));

        vm.prank(USER2);
        todo.createtask("task2");

        

        uint newIndex= todo.getIndex();
        address newUser= todo.getListOwnerId(newIndex);

        assertEq(oldIndex, newIndex);
        assertEq(oldUser, newUser);
        assertEq(todo.getListOwnerId(oldIndex + 1), address(0));

    }

    function testCreateMultipleTasksForSameUser()public{

        address addr = address(1);

        for(uint160 i=1 ;i<=10;i++){

            vm.prank(addr);
            todo.createtask("task1");

            (uint id ,,)=todo.getTask(addr,i-1);

            assertEq(id,i);
        }
    }

    function testCreateTasksForDifferentUsers()public{

        //Task created by one user
        address addr1 =address(1);
        vm.prank(addr1);
        todo.createtask("task1");

        uint oldSizeOfTask= todo.getTaskIndex(addr1);

        //Task created by next user
        address addr2 =address(2);
        vm.prank(addr2);
        todo.createtask("task2");

        //Check the task are isolated or not
        uint newSizeOfTask= todo.getTaskIndex(addr1);
        (uint id1 ,string memory titile1,)= todo.getTask(addr1, 0);
        (uint id2 ,string memory titile2,)= todo.getTask(addr2, 0);
        

        assertEq(id1, 1);
        assertEq(id2, 1);

        assertEq(oldSizeOfTask, newSizeOfTask);

        assertEq(titile1, "task1");
        assertEq(titile2, "task2");

    }


    function testGetListOwnerAllTaskReturnsCallerTasks()public createTaskMod{
        vm.prank(USER2);
        string memory title2=todo.getListOwnerAlltask()[0].title;

        (,string memory title,)=todo.getTask(USER2, 0);
        
        assertEq(title,title2);
    }


function testGetTaskWithCorrectIndex() public {
    address user = USER2;

    // Arrange: create multiple tasks
    vm.prank(user);
    todo.createtask("task1");

    vm.prank(user);
    todo.createtask("task2");

    // Act: fetch second task (index = 1)
    (uint256 id, string memory title, bool completed) = todo.getTask(user, 1);

    // Assert
    assertEq(id, 2);
    assertEq(title, "task2");
    assertFalse(completed);
}

function testTaskRemovedProperly()public createTaskMod{
    vm.prank(USER2);

    todo.removeTask(0);

    vm.prank(USER2);
    assertEq(todo.getListOwnerAlltask().length,0);
    
}

function testAfterRemovingTaskOrder()public{
    for (uint160 i = 0; i < 3; i++) {
        vm.prank(USER2);
        todo.createtask("task");
    }

    vm.prank(USER2);
    todo.removeTask(0);

    vm.prank(USER2);
    uint id1 =todo.getListOwnerAlltask()[0].id;
    vm.prank(USER2);
    uint id2 =todo.getListOwnerAlltask()[1].id;

    assertEq(id1, 2);
    assertEq(id2, 3);

}



    modifier createTaskMod {
        vm.prank(USER2);
        todo.createtask("Task created");
        _;        
    }
}