pragma solidity 0.4.17;
import "./VierGewinnt.sol";


contract VierGewinntFactory {

    event VierGewinntCreation(address creator, VierGewinnt vierGewinnt);

    function create(address[] players)
        public
        returns (VierGewinnt vierGewinnt)
    {
        vierGewinnt = new VierGewinnt(players);
        VierGewinntCreation(msg.sender, vierGewinnt);
    }
}
