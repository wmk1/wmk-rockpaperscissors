pragma solidity ^0.5.0;

contract RockPaperScissors {

    uint public winningAmount;

    enum Move {NONE, ROCK, PAPER, SCISSORS}

    constructor() public {
    }

    function () external payable {
    }

    struct Player {
        address payable player;
        uint deposit;
        bytes32 moveHashed;
        Move move;
        bool moveValidated;
    }

    Player[2] players;

    uint public playerCount = 0;

    modifier onlyIfTwoPlayers {
        require(playerCount == 2);
        _;
    }

    modifier onlyIfMovesSubmitted(uint _playerAIndex, uint _playerBIndex) {
        require(players[_playerAIndex].moveSubmitted == true && players[_playersBIndex].moveSubmitted == true, "Two players must bet game");
        _;
    }



    function makeMove(bytes32 _hashedMove) public payable returns (bool success) {
        playerCount +=1;
        require(playerCount <= 2, "...so far only two players can play");
        players[playerCount].player = msg.sender;
        players[playerCount].deposit = msg.value;
        players[playerCount].moveHashed = _hashedMove;
        return success;
    }

    function unhashMove(Move _move, string memory _password) public returns(bool success) {
        uint playerIndex = 0;
        Player memory player = players[playerIndex];
        bytes32 playerMove = player.moveHashed;
        require(playerMove == keccak256(abi.encodePacked(_move, _password)), "Wrong move or password!");
        player.move = _move;
        player.moveValidated = true;
    }

    function betGame() public payable returns(bool success) {
        winningAmount += players[0].deposit;
        winningAmount += players[1].deposit;
        uint winnerIndex = compareMoves(players[0].move, players[1].move);
        if (winnerIndex == 0) {
            uint halfWinningAmount = (winningAmount % 2) / 2;
            players[0].player.transfer(halfWinningAmount);
            players[1].player.transfer(halfWinningAmount);
        }
        if (winnerIndex == 1) {
            players[0].player.transfer(winningAmount);
        }
        if (winnerIndex == 2) {
            players[1].player.transfer(winningAmount);
        }
        return true;
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


    function exitGame() public payable returns (bool success) {
        if (players[1].player == msg.sender) {
            playerCount -= 1;
            players[1].player.transfer(players[1].deposit);
            return true;
        }
    }
}