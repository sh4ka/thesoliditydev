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
    
    enum State { Open, Closed, Ended }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
 
    function Bet(address _proposer) public payable {
        owner = msg.sender;
        proposer = _proposer;
    }
    
    function bet() public payable {
        
    }
    
    function setTerms(string _terms) public onlyOwner  {
        terms = _terms;
    }
    
    function setOutcome(string _outcome) public onlyOwner  {
        outcome = _outcome;
    }
}
