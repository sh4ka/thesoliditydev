pragma solidity ^0.4.19;
 
/// @title Basic lottery
/// Very basic lottery for learning purposes
/// The contract owner needs to provide the lucky number using, for example
/// the UK National Lottery winner or similar in the range 0-99999
contract Lottery {
    
    // lottery states
    enum State { Open, Closed, Ended }
    // current lottery state
    State public state;

    // bet struct
    struct Bet {
        address owner;
        uint num;
    }
    
    // list of bets, this is a list of Bet structs
    Bet[] public bets;
    // list of winners to split the price
    Bet[] public winners;

    address public owner;
    uint public winningNumber;
    uint public numberOfBets;
    uint public amountAccummulated;

    // how much to transfer per winner
    uint prizePerWinner;
    
    // bet size in wei, this is 0.0005 eth ~ $0.60
    uint betSize = 500000000000000;
    
    // some modifiers
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier notOwner() {
        require(msg.sender != owner);
        _;
    }
    
    modifier onlyWinners() {
        bool isAWinner = false;
        for(uint i = 0; i <= winners.length; i++){
            if(msg.sender == winners[i].owner) {
                isAWinner = true;
                break;
            }
        }
        require(isAWinner);
        _;
    }
    
    modifier inState(State _state) {
        require(state == _state);
        _;
    }
    
    // contract construct, set here any initial states
    function Lottery() public {
        owner = msg.sender;
        state = State.Open;
    }
    
    function accumulated() public view returns (uint) {
        return amountAccummulated;
    }
    
    function placeBet(uint _num) public notOwner inState(State.Open) payable {
        require(_num >= 0 && _num < 100000); // allowed numbers
        if(msg.value == betSize) {
            numberOfBets += 1;
            amountAccummulated += msg.value;
            bets.push(
                Bet({owner: msg.sender, num: _num})
            );
        }
    }
    
    function getBet(uint _position) public view returns (uint) {
        return bets[_position].num;
    }
    
    function getNumberOfBets() public view returns (uint) {
        return numberOfBets;
    }
    
    function openLottery() public onlyOwner {
        state = State.Open;
    }
    
    function closeLottery() public onlyOwner {
        state = State.Closed;
    }
    
    function withdrawAccumulated() public onlyWinners notOwner inState(State.Ended) {
        uint amount = prizePerWinner;
        // this is to zero the pending refund before
        // sending to prevent re-entrancy attacks
        amountAccummulated -= prizePerWinner;
        msg.sender.transfer(amount);
    }
    
    function setWinningNumber(uint _num) public onlyOwner inState(State.Closed) {
        winningNumber = _num;
        state = State.Ended;
        for(uint i = 0; i <= numberOfBets; i++ ) {
            if(bets[i].num == winningNumber) {
                winners.push(bets[i]);
            }
            if(winners.length > 0){
                prizePerWinner = amountAccummulated / winners.length;
            }
        }
    }
}