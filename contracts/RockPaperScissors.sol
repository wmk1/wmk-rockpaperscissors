pragma solidity ^0.5.0;

contract RockPaperScissors {

    uint public winningAmount;

    enum Move {NONE, ROCK, PAPER, SCISSORS}

    constructor() public {
    }

    function () external payable {
    }

    struct Player {
        address player;
        uint deposit;
        bytes32 moveHashed;
        bool moveSubmitted;
    }

    Player[2] players;

    uint public playerIndex = 0;

    function makeMove(bytes32 _hashedMove) public payable returns (bool success) {
        playerIndex +=1;
        players[playerIndex].player = msg.sender;
        players[playerIndex].deposit = msg.value;
        players[playerIndex].moveHashed = _hashedMove;
        players[playerIndex].moveSubmitted = true;
        return success;
    }

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

    function hashMove(Move _move, string memory _password) public pure returns (bytes32 moveHashed) {
        return keccak256(abi.encodePacked(_move, _password));
    }


   
}