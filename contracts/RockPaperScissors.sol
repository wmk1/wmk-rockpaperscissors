pragma experimental ABIEncoderV2;

contract RockPaperScissors {

    enum Shape { ROCK, PAPER, SCISSORS}

    struct Player {
        uint balance;
        address owner;
        Shape shape;
    }

    mapping(address => Player) public players;

    event LogWinner(address player);

    constructor(address _bob) public {
        Player memory alice = players[msg.sender];
        alice.owner = msg.sender;
        Player memory bob = players[_bob];
        bob.owner = _bob;
        alice.balance = 1000000;
        bob.balance = 1000000;
    }

    function emergeWinner(Shape aliceShape, Shape bobShape) private view returns (Player winner) {
        if (aliceShape == bobShape) {
            revert("A tie. Nothing happens. end of story.");
        }
        if (aliceShape == Shape.ROCK) {
            if (bobShape == Shape.PAPER) {
                return players[1];
            }
            else {
                return players[0];
            }
        }
        if (aliceShape == Shape.PAPER) {
            if (bobShape == Shape.SCISSORS) {
                return players[1];
            }
            else {
                return players[0];
            }
        }
        if (aliceShape == Shape.SCISSORS) {
            if (bobShape == Shape.ROCK) {
                return players[1];
            }
            else {
                return players[0];
            }
        }
        else {
            revert("WTF just happened, I dont even");
        }
    }

    function betGame(uint _aliceBalance, uint _bobBalance, uint betAmount) public payable returns (bool success) {
        require(betAmount >= 0); 
        uint bet;
        bet += betAmount * 2;
        players[0].balance -= betAmount;
        players[1].balance -= betAmount;
        return true;
    }

    function play(Player _bob, uint amount) public payable returns (bool success) {
        betGame(msg.sender.balance, _bob.balance, amount);
        require(_bob.owner != 0);
        require(amount >= 0);
        Player memory winner = emergeWinner(players[0].shape, players[1].shape);
        return true;
    }
}