// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TodoApp {

   struct List{
    uint256 id;
    string title;
    bool completed;
   }


mapping (uint256 => address)private listOwnerId;
mapping (address => List[]) private task;            
mapping (address => bool) private isRegistred;
uint256 private index;
address immutable private i_owner;


   constructor() {
      i_owner=msg.sender;
   }


   function createtask(string memory _task) public {

      uint256 taskIndex=task[msg.sender].length+1;
      index++;

      if(!isRegistred[msg.sender]){
         listOwnerId[index]=msg.sender;
         isRegistred[msg.sender]=true;
      }

    List memory l =List(taskIndex,_task,false);
    task[msg.sender].push(l); //Addin in task
   }

   function getListOwnerAlltask()public view returns(List[] memory){
      return task[msg.sender];
   }

   function getAlltaskOfAllUser(uint _index)public view returns(List[] memory){
      require(msg.sender==i_owner,"you are not owner");
      return task[listOwnerId[_index]];
   }

   function setTastcompleted(uint256 _index)public returns(List memory){
      require(_index<task[msg.sender].length, "This taks do not exist");
      
      task[msg.sender][_index].completed=true;
      return task[msg.sender][_index];
   }
  




//Geters
   function getOwner() public view returns(address){
      return i_owner;
   }

   function getListOwnerId(uint256 _index) public view returns(address){
      return listOwnerId[_index];
   }

   function getTask(address addr,uint _index) view public returns(
   uint256,
   string memory ,
   bool 
   )
   {
      List memory l = task[addr][_index];
      return (l.id ,l.title ,l.completed);
   }   

   function getIsRegistered(address addr)public view returns(bool){
      return isRegistred[addr];
   }

   function getIndex()public view returns(uint){
      return index;
   }
}
