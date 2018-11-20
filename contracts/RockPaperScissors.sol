pragma solidity ^0.4.24;

contract RockPaperScissors {

    enum Shape {NONE, ROCK, PAPER, SCISSORS}

    struct Player {
        address owner;
        uint bet;
        bytes32 hashedMove;
    }
    bool hasAliceBet;
    bool hasBobBet;

    uint bet;
    address owner;

    Shape aliceMove;
    Shape bobMove;

    bytes32 hashedAliceMove;
    bytes32 hashedBobMove;

    mapping(address => Player) public players;

    event LogWinner(address player);
    event LogEtherDeposed(uint _amount);

    modifier onlyIfMovesSubmitted() {
        require(hashedAliceMove != bytes32(0) && hashedBobMove != bytes32(0));
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function compareMoves(Shape aliceMove, Shape bobMove) public view returns (Player winner) {
        if (aliceMove == bobMove) {
            revert("A tie. Nothing happens");
        }
        if (aliceMove == Shape.ROCK) {
            if (bobMove == Shape.PAPER) {
                return players[1];
            }
            else {
                return players[0];
            }
        }
        if (aliceMove == Shape.PAPER) {
            if (bobMove == Shape.SCISSORS) {
                return players[1];
            }
            else {
                return players[0];
            }
        }
        if (aliceMove == Shape.SCISSORS) {
            if (bobMove == Shape.ROCK) {
                return players[1];
            }
            else {
                return players[0];
            }
        }
        else {
            revert("Error occured");
        }
    }

    function betGame(bytes32 _hashedMove) public payable {
        if (!hasAliceBet) {
            hasAliceBet = true;
            players[0].bet += msg.value;
            players[0].owner = msg.sender;
            players[0].hashedMove = _hashedMove;
        } else {
            require(bet == msg.value);
            hasBobBet = true; 
            players[1].bet += msg.value;
            players[1].owner = msg.sender;
            players[1].hashedMove = _hashedMove;
        }
    }

    function play() public payable onlyIfMovesSubmitted returns (bool) {
        require(msg.sender != 0);
        Player memory winner = compareMoves(aliceMove, bobMove);
        emit LogWinner(winner.owner); 
        return true;
    }

    function hashPlay(address _player, string _move) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(_player, _move));
    }

    function kill() public {
        selfdestruct(owner);
    }

    function() public {
        revert();
    }
}