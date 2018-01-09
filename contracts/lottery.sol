pragma solidity ^0.4.11;
 
contract Lottery {
 
    mapping(address => uint) usersNumbers;
    mapping(address => uint) usersBets;
    mapping(uint => address) users;
    uint public totalBets = 0;
    uint public accumulated = 0;
    string secretHash;
    
    uint betSize = 1000000000000000;
    
    bool ended;
 
    address owner;
    address winner;
    uint luckyNumber;
 
    function Lottery() public {
        owner = msg.sender;
    }
    
    function accumulated() public constant returns (uint) {
        return accumulated;
    }
    
    function isEnded() public constant returns (bool) {
        return ended;
    }
    
    function getLuckyNumber() public constant returns (uint) {
        if(ended == true){
            return luckyNumber;
        }
    }
    
    function bet(uint number) public payable  {
        if (msg.value == betSize && number >= 0 && number < 100000) {
            totalBets += 1;
            users[number] = msg.sender;
            usersNumbers[msg.sender] += number;
            usersBets[msg.sender] += number;
            accumulated += msg.value;
        }
    }
    
    function endLottery(uint winningNumber) public returns (bool) {
        if (msg.sender == owner && ended == false) {
            ended = true;
            luckyNumber = winningNumber;
            winner = users[luckyNumber];
            return true;
        }
        return false;
    }
    
    function withdraw() public returns (bool) {
        if(msg.sender == winner && ended == true) {
            uint amount = accumulated;
            if (amount > 0) {
                // It is important to set this to zero because the recipient
                // can call this function again as part of the receiving call
                // before `send` returns.
                accumulated = 0;
    
                if (!msg.sender.send(amount)) {
                    // No need to call throw here, just reset the amount owing
                    accumulated = amount;
                    return false;
                }
            }
            return true;
        }
    }
}