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
    uint numberOfBets = 0;
    PlacedBet[] public winningBets;
    
    uint accumulated;
    uint prize;
    
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
    
    function openLottery() external isClosed onlyOwner {
        state = State.Open;
    }
    
    function closeLottery() external isOpen onlyOwner {
        state = State.Closed;
    }
    
    function endLottery() external isClosed onlyOwner {
        state = State.Ended;
    }
    
    function setTerms(string _terms) external isOpen onlyOwner  {
        terms = _terms;
    }
    
    function setOutcome(string _outcome) external isOpen onlyOwner  {
        outcome = _outcome;
    }
    
    function bet(string _outcome) external isOpen payable {
        bytes memory tempEmptyStringTest = bytes(_outcome); // use memory here
        if(tempEmptyStringTest.length != 0 && msg.value > 0){
            numberOfBets += 1;
            accumulated += msg.value;
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
    
    function setWinners(string _outcome) external onlyOwner isClosed {
        for(uint i = 0; i < placedBets.length; i++) {
            if(keccak256(_outcome) == keccak256(placedBets[i].outcome)) {
                winningBets.push(placedBets[i]);
            }
        }
    }
    
    function allocatePrize() external view onlyOwner isEnded {
        prize = 0;
        require(accumulated > 0 && winningBets.length > 0);
        prize = uint(accumulated / winningBets.length);
    }
    
}
