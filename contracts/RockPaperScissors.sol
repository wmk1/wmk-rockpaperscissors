pragma solidity ^0.5.0;

contract RockPaperScissors {

    uint public winningAmount;

    enum Move {NONE, ROCK, PAPER, SCISSORS}

    constructor() public {
    }

    function () public payable {
    }

    struct Player {
        uint deposit;
        bytes32 moveHashed;
        bool moveSubmitted;
    }

    mapping (address => Player) players;

    function compareMoves(Move _firstMove, Move _secondMove) public returns (uint winner) {
        if (_firstMove == _secondMove) {
            return 0;
        }
        if (_firstMove == Move.ROCK) {
            if (_secondMove == Move.PAPER) {
                return 2;
            } 
            return 1;
        } 
        if (_firstMove == Move.PAPER) {
            if (_secondMove == Move.SCISSORS) {
                return 2;
            }
            return 1;
        }
        if (_firstMove == Move.SCISSORS) {
            if (_secondMove == Move.ROCK) {
                return 2;
            }
            return 1;
        }
    }

    function hashMove(Move _move, string _password) public returns (bytes32 moveHashed) {
        return keccak256(abi.encodePacked(_move, _password));
    }


   
}