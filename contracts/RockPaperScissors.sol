pragma solidity ^0.4.24;

contract RockPaperScissors {

    enum Shape {NONE, ROCK, PAPER, SCISSORS}

    struct Player {
        address owner;
        uint bet;
        bytes32 encryptedMove;
    }
    bool hasAliceBet;
    bool hasBobBet;

    uint bet;
    address owner;

    Shape aliceMove;
    Shape bobMove;

    bytes32 hashedAliceMove;
    bytes32 hashedBobMove;

    uint constant aliceIndex = 0;
    uint constant bobIndex = 1;

    mapping(address => Player) public players;

    event LogWinner(uint playerIndex);
    event LogEtherDeposed(uint _amount);

    modifier onlyIfMovesSubmitted() {
        require(hashedAliceMove != bytes32(0) && hashedBobMove != bytes32(0));
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function compareMoves(Shape aliceMove, Shape bobMove) public view returns (uint winner) {
        if (aliceMove == bobMove) {
            return 0;
        }
        if (aliceMove == Shape.ROCK) {
            if (bobMove == Shape.PAPER) {
                return bobIndex;
            }
            else {
                return aliceIndex;
            }
        }
        if (aliceMove == Shape.PAPER) {
            if (bobMove == Shape.SCISSORS) {
                return bobIndex;
            }
            else {
                return aliceIndex;
            }
        }
        if (aliceMove == Shape.SCISSORS) {
            if (bobMove == Shape.ROCK) {
                return bobIndex;
            }
            else {
                return aliceIndex;
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
            players[0].encryptedMove = _hashedMove;
        } else {
            require(bet == msg.value);
            hasBobBet = true; 
            players[1].bet = msg.value;
            players[1].owner = msg.sender;
            players[1].encryptedMove = _hashedMove;
        }
    }

    function play() public payable onlyIfMovesSubmitted returns (bool) {
        uint gameWinner = compareMoves(aliceMove, bobMove);
        emit LogWinner(players[gameWinner]); 
        return true;
    }

    function hashPlay(address _player, string _move) public pure returns (bytes32) {
        bytes32 result = keccak256(abi.encodePacked(_player, _move));
        return result;
    }

    function kill() private {
        selfdestruct(owner);
    }

    function() public {
        revert();
    }
}