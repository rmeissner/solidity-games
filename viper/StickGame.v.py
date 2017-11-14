players: public(address[2])
sticks: public(num)
minBet: public(wei_value)
is_player: bool[address]
has_set_bet: bool[address]
current_player: num
state: num

def __init__(_players: address[2], _start_sticks: num, _minBet: wei_value):
    for i in range(2):
        assert not not _players[i] and not self.is_player[_players[i]]
        self.is_player[_players[i]] = True

    self.players = _players
    self.sticks = _start_sticks
    self.minBet = _minBet
    self.state = 0

@internal
def next_player():
    self.current_player += 1
    if (self.current_player >= 2):
        self.current_player = 0

@payable
def set_bet():
    assert self.state == 0
    assert self.is_player[msg.sender]
    assert msg.value >= self.minBet
    self.has_set_bet[msg.sender] = true
    for i in range(2):
        if (not self.has_set_bet[self.players[i]]):
            return
    self.state = 1

def take_sticks(amount: num):
    assert self.state == 1
    assert msg.sender == self.players[self.current_player]
    assert amount > 0 and amount < 5
    assert (self.sticks - amount) >= 0
    self.sticks = self.sticks - amount
    if (self.sticks > 0):
        self.next_player()
    else:
        self.state = 2

def getWinnings():
    assert self.state == 2
    assert msg.sender == self.players[self.current_player]
    selfdestruct(self.players[self.current_player])
