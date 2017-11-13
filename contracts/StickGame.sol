pragma solidity 0.4.17;

contract StickGame {
  uint8 public constant MIN_STICK_TAKE = 1;
  uint8 public constant MAX_STICK_TAKE = 5;
  uint8 public constant MAX_PLAYERS = 4;
  uint8 public constant MIN_STICKS_AMOUNT = 42;
  uint8 public constant MIN_PLAYERS = 2;

  event NewPlayer(address owner);
  event GameCreated(uint8 sticks, uint betAmount);

  enum Stages {
    Created,
    Running,
    GameOver
  }

  modifier atStage(Stages _stage) {
    require(stage == _stage);
    _;
  }

  modifier onlyHasSetBet() {
    require(hasSetBet[msg.sender]);
    _;
  }

  modifier onlyPlayer() {
    require(isPlayer[msg.sender]);
    _;
  }

  modifier onlyCurrentPlayer() {
    require(msg.sender == players[currentPlayer]);
    _;
  }

  Stages public stage = Stages.Created;

  uint8 public sticks;
  uint public currentPlayer;
  uint public betAmount;
  address[] public players;
  mapping (address => bool) public hasSetBet;
  mapping (address => bool) public isPlayer;

  function StickGame(address[] _players, uint8 _startSticks, uint _betAmount)
    public
  {
    require(_players.length <= MAX_PLAYERS && _players.length >= MIN_PLAYERS && _startSticks > MIN_STICKS_AMOUNT);
    for (uint i = 0; i < _players.length; i++) {
        require(_players[i] != 0 && !isPlayer[_players[i]]);
        isPlayer[_players[i]] = true;
        NewPlayer(_players[i]);
    }
    sticks = _startSticks;
    players = _players;
    betAmount = _betAmount;
    GameCreated(sticks, betAmount);
  }

  function ()
      external
      payable
  {
  }

  function bet()
      external
      payable
      atStage(Stages.Created)
      onlyPlayer()
  {
    require(msg.value >= betAmount);
    uint returned = msg.value - betAmount;
    hasSetBet[msg.sender] = true;
    msg.sender.transfer(returned);

    for (uint i = 0; i < players.length; i++) {
        if (!hasSetBet[players[i]])
          return;
    }
    stage = Stages.Running;
  }

  function cancelBet()
    external
    atStage(Stages.Created)
    onlyPlayer()
    onlyHasSetBet()
  {
    hasSetBet[msg.sender] = false;
    msg.sender.transfer(betAmount);
  }

  function takeSticks(uint8 amount)
    public
    atStage(Stages.Running)
    onlyCurrentPlayer
  {
    require(amount >= MIN_STICK_TAKE && amount <= MAX_STICK_TAKE && sticks - amount >= 0);
    sticks = sticks - amount;
    if (sticks > 0) {
      nextPlayer();
    } else {
      stage = Stages.GameOver;
    }
  }

  function getWinning()
    public
    atStage(Stages.GameOver)
    onlyCurrentPlayer
  {
    selfdestruct(msg.sender);
  }

  function nextPlayer()
    private
  {
    currentPlayer = (currentPlayer + 1) % players.length;
  }
}
