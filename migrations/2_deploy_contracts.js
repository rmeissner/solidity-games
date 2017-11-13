var StickGameFactory = artifacts.require("./StickGameFactory.sol");

module.exports = function(deployer) {
  deployer.deploy(StickGameFactory);
};

/*
StickGameFactory.at("0xc6fc5e99b5d253f6eabf53fb2eab94af4e6a1444").create(["0xa5056c8efadb5d6a1a6eb0176615692b6e648313","0x9bebe3b9e7a461e35775ec935336891edf856da2"], 500, 50).then((resp) => {console.log(resp['receipt']['logs'][0]['address'])})
var game = StickGame.at("0xf11a8aeb3ab2de16060d96ac977070b2b6aa1c21")
game.bet({value: 50});game.bet({value: 50, from: "0x9bebe3b9e7a461e35775ec935336891edf856da2"});game.stage.call() // => should be 1
game.takeSticks(4);game.takeSticks(4, {from: "0x9bebe3b9e7a461e35775ec935336891edf856da2"});game.sticks.call() // => should count down, go to next if 0
game.currentPlayer.call() // => currentPlayer == winner
web3.eth.getBalance("0xa5056c8efadb5d6a1a6eb0176615692b6e648313") // => balance before getWinning()
game.getWinnings() // transfer winnings
web3.eth.getBalance("0xa5056c8efadb5d6a1a6eb0176615692b6e648313") // => balance after getWinning()
*/
