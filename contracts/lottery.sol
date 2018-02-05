pragma solidity ^0.4.19;
 
/// @title Basic betting system factory
/// Basic betting system in which a user can propose new bets and create 
/// their own betting contracts
/// The contract deployer has to provide a description of the rules to be 
/// agreed on when creating the bet, the outcomes have to be given in the form
/// of a regexp

contract Bet {

    address owner;
    address proposer;
    
    string terms;
    string outcome;
    
    struct PlacedBet {
        address owner;
        uint amount;
        string outcome;
        bool isAWinner;
        bool prizeWithdrawn;
    } 
    // list of bets, this is a list of Bet structs
    PlacedBet[] public placedBets;
    PlacedBet[] winningBets;
    uint numberOfBets = 0;
    
    enum State { Open, Closed, Ended }
    State public state;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier isOpen() {
        require(state == State.Open);
        _;
    }
    
    modifier isClosed() {
        require(state == State.Closed);
        _;
    }
    
    modifier isEnded() {
        require(state == State.Ended);
        _;
    }
 
    function Bet(address _proposer) public payable {
        owner = msg.sender;
        proposer = _proposer;
        state = State.Open;
    }
    
    function openLottery() public isClosed onlyOwner {
        state = State.Open;
    }
    
    function closeLottery() public isOpen onlyOwner {
        state = State.Closed;
    }
    
    function endLottery() public isClosed onlyOwner {
        state = State.Ended;
    }
    
    function bet(string _outcome) public isOpen payable {
        bytes memory tempEmptyStringTest = bytes(_outcome); // use memory
        if(tempEmptyStringTest.length != 0){
            numberOfBets += 1;
            placedBets.push(
                PlacedBet(
                    {
                        owner: msg.sender,
                        amount: msg.value,
                        outcome: _outcome, 
                        isAWinner: false,
                        prizeWithdrawn: false
                    }
                )
            );
        }
    }
    
    function chooseWinner() public isClosed onlyOwner {
        endLottery();
        for(uint i = 0; i < placedBets.length; i++){
            if(true == compareStrings(outcome, placedBets[i].outcome)){
                winningBets.push(placedBets[i]);
            }
        }
    }
    
    function setTerms(string _terms) public isOpen onlyOwner  {
        terms = _terms;
    }
    
    function setOutcome(string _outcome) public isOpen onlyOwner  {
        outcome = _outcome;
    }
    
    function compareStrings (string a, string b) pure public returns (bool){
       return keccak256(a) == keccak256(b);
    }
}

