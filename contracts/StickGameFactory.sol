pragma solidity 0.4.17;
import "./StickGame.sol";


contract StickGameFactory {

    event StickGameCreation(address creator, StickGame stickGame);

    function create(address[] players, uint8 sticks, uint betAmount)
        public
        returns (StickGame stickGame)
    {
        stickGame = new StickGame(players, sticks, betAmount);
        StickGameCreation(msg.sender, stickGame);
    }
}
