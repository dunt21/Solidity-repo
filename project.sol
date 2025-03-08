// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.19;

 
 contract bankingApp{
uint public userBalance;
 uint public transactionId;

  struct transactions{
    uint idNum;
    address user;
    uint time;
    string ref;
    string network; 
    uint amt;
    uint userBalance;
  }

  transactions [] public  arrTransactions;

  modifier checkAmt (uint amt){
    require (amt <= userBalance, "Your account balance is low");
    _;
  }

  function deposit (uint _depositAmt,  string memory _ref, string memory _network ) public {
 transactionId++;

       userBalance += _depositAmt;
       
       arrTransactions.push(transactions(
        transactionId,
       msg.sender,
       block.timestamp,
       _ref,
       _network,
       _depositAmt,
       userBalance 
       ));


  }

  function withdraw (uint withdrawAmt, string memory _ref, string memory _network ) public checkAmt(withdrawAmt) {
   transactionId++;
    userBalance -= withdrawAmt;

    arrTransactions.push(transactions(
      transactionId,
      msg.sender,
      block.timestamp,
      _ref,
      _network,
      withdrawAmt,
      userBalance
    ));
  }

  

  function viewOneTransaction ( uint _id)public view returns (transactions memory) {
    return arrTransactions[_id];

  }

  function viewAllTransactions() public view returns (transactions [] memory){
    return arrTransactions;
  }
 }
 