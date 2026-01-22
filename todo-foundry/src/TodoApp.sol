// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TodoApp {

   struct List{
    uint256 id;
    string title;
    bool completed;
   }


mapping (uint256 userId => address user)private listOwnerId;
mapping (address user => List[] listOfTask) private task;            
mapping (address user => bool isUser) private isRegistred;
mapping (address user => uint taskIndex)private taskIndex;
uint256 private index;
address immutable private i_owner;


   constructor() {
      i_owner=msg.sender;
   }


   function createtask(string memory _task) public {
      //logic for account holder task id
     address sender=msg.sender;
      

      if(!isRegistred[sender]){
         index++;
         listOwnerId[index]=sender; //GIVING UNIQUES INDEX TO EACH NEW USER
         isRegistred[sender]=true; //REGISTERING THE USER
         taskIndex[sender]=0; // SETING TASK ID TO 0
      }
      taskIndex[sender]++;

    List memory l =List(taskIndex[sender],_task,false);
    task[sender].push(l); //Addin in task
   }

   function removeTask(uint256 _index) public {
    List[] storage l = task[msg.sender];

    require(_index < l.length, "Invalid index");

    for (uint256 i = _index; i < l.length - 1; i++) {
        l[i] = l[i + 1];
    }

    l.pop();
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
   function getTaskIndex(address addr)public view returns(uint){
      return taskIndex[addr];
   }
}
