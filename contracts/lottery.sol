pragma solidity ^0.4.19;
 
contract Lottery {

    struct Bet {
        address owner;
        uint num;
    }
    
    mapping(uint => Bet[]) public bets;

    address owner;
    uint winningNumber;
    uint numberOfBets;
    uint amountAccummulated;
    
    uint betSize = 500000000000000;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier notOwner() {
        require(msg.sender != owner);
        _;
    }
    
    function Lottery() public {
        owner = msg.sender;
    }
    
    function accumulated() public returns (uint) {
        return amountAccummulated;
    }
    
    function placeBet(uint _num) public notOwner payable {
        if(msg.value == betSize) {
            require(_num >= 0 && _num < 100000);
            numberOfBets += 1;
            amountAccummulated += msg.value;
            bets[numberOfBets].push(
                Bet({owner: msg.sender, num: _num})
            );
        }
    }
    
    function setWinningnumber(uint _num) public onlyOwner {
        winningNumber = _num;
    }
}