Promise = require("bluebird");
const Web3 = require('web3');

const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const RockPaperScissors = artifacts.require("./RockPaperScissors.sol");

Promise.promisifyAll(web3.eth, { suffix: "Promise" });

contract("RockPaperScissors contract", (accounts) => {

    let alice;
    let bob;
    let carol;
    
    const NONE = 0;
    const ROCK = 1;
    const PAPER = 2;
    const SCISSORS = 3;

    const aliceSecret = "secret1";
    const bobSecret = "secret2";

    [alice, bob, carol] = accounts;

    let contractInstance;
    before("Checking if smart contract is setup properly -  accounts", () => {
        assert.isAtLeast(accounts.length, 3, "not enough, something is wrong here....");

        console.log("Owner: " + alice);
        console.log("Bob: " + bob);
        console.log("Carol: " + carol);

        contractInstance = RockPaperScissors.new(bob, {from: alice});
        return web3.eth.getBalance(alice)
            .then(_balance => {
                console.log("Alice balance: " + _balance);
            });
    });

    it("Should fail while betting game ",  () => {
        //given
        const aliceMove = ROCK;
        const bobMove = SCISSORS;

        const aliceHashedMove = contractInstance.

        //when
        return contractInstance.({ value: amountSended, from: alice})
            //then
            .then(txReceipt => {
                let eventNames = txReceipt.logs.filter(log => log.event == "LogEtherSended");
                assert(eventNames.length > 0, "No LogEtherSended events found, is it surely emitted?");
                assert.equal(eventNames[0].event, "LogEtherSended", "Some obstruction occured,");
                return contractInstance.balances(carol)
            })
            //then
            .then(_carol => {
                carol = _carol;
                assert.strictEqual(carol, expectedAmount.toString(10));
            });
    });
});
