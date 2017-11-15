pragma solidity 0.4.17;

contract VierGewinnt {
  event VierGewinntGameCreated(address player1, address player2);

  uint8 public constant WIN_STONES = 4;
  uint8 public constant COLUMN_HEIGHT = 5;

  enum Stages {
    Created,
    Running,
    GameOver
  }

  modifier onlyCurrentPlayer() {
    require(msg.sender == players[currentPlayer]);
    _;
  }

  modifier atStage(Stages _stage) {
    require(stage == _stage);
    _;
  }

  uint8[][7] field;
  address[] public players;
  uint public currentPlayer;
  mapping (address => bool) public isPlayer;
  mapping (address => uint8) public playerNumber;
  Stages public stage = Stages.Created;

  function VierGewinnt(address[] _players)
    public
  {
    require(_players.length == 2);
    for (uint8 i = 0; i < _players.length; i++) {
        require(_players[i] != 0 && !isPlayer[_players[i]]);
        isPlayer[_players[i]] = true;
        playerNumber[_players[i]] = i + 1;
    }
    players = _players;
    stage = Stages.Running;
    VierGewinntGameCreated(_players[0], _players[1]);
  }

  function addStone(uint column)
    public
    atStage(Stages.Running)
    onlyCurrentPlayer()
  {
    require(column >= 0 && column < field.length
      && field[column].length < COLUMN_HEIGHT);
    uint row = field[column].length;
    field[column].push(playerNumber[msg.sender]);

    if (check(column, row, playerNumber[msg.sender])) {
      stage = Stages.GameOver;
    } else {
      currentPlayer = (currentPlayer + 1) % players.length;
    }
  }

  function check(uint startColumn, uint startRow, uint8 expectedPlayer)
    public
    view
    returns (bool)
  {
    // Check top left to bottom right
    uint8 stones = 1;
    stones += checkDirection(-1, 1, startColumn, startRow, expectedPlayer);
    if (stones >= WIN_STONES) {
      return true;
    }
    stones += checkDirection(1, -1, startColumn, startRow, expectedPlayer);
    if (stones >= WIN_STONES) {
      return true;
    }

    // Check bottom left to top right
    stones = 1;
    stones += checkDirection(-1, -1, startColumn, startRow, expectedPlayer);
    if (stones >= WIN_STONES) {
      return true;
    }
    stones += checkDirection(1, 1, startColumn, startRow, expectedPlayer);
    if (stones >= WIN_STONES) {
      return true;
    }

    // Check horizontal
    stones = 1;
    stones += checkDirection(-1, 0, startColumn, startRow, expectedPlayer);
    if (stones >= WIN_STONES) {
      return true;
    }
    stones += checkDirection(1, 0, startColumn, startRow, expectedPlayer);
    if (stones >= WIN_STONES) {
      return true;
    }

    // Check vertical (down only)
    stones = 1;
    stones += checkDirection(0, -1, startColumn, startRow, expectedPlayer);
    if (stones >= WIN_STONES) {
      return true;
    }
    return false;
  }

  function checkDirection(int dx, int dy, uint startColumn, uint startRow, uint8 expectedPlayer)
    private
    view
    returns (uint8 stones)
  {
    stones = 0;
    int column = int(startColumn);
    int row = int(startRow);

    do {
      column = column + dx;
      row = row + dy;
      if (row < 0 || column < 0 ||
            uint(column) >= field.length || uint(row) >= field[uint(column)].length)
        break;

      stones++;
      if (stones >= WIN_STONES)
        break;
    } while(field[uint(column)][uint(row)] == expectedPlayer);
  }

  function columns()
    public
    view
    returns (uint)
  {
    return field.length;
  }

  function columnHeight(uint column)
    public
    view
    returns (uint)
  {
    return field[column].length;
  }

  function fieldStatus(uint column, uint row)
    public
    view
    returns (uint8)
  {
    require (column >= 0 && column < field.length && row >= 0 && row <= COLUMN_HEIGHT);
    if (row >= field[column].length) {
      return 0;
    }
    return field[column][row];
  }
}
