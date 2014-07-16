require 'board'

class Game
  attr_reader :players, :board, :display

  def initialize(players, board, display)
    @players = players
    @board   = board
    @display = display
  end

  def start
    begin
      begin
        ensure_enough_players

        display_board
        place_move_of(players.first)
        switch_players
      rescue Board::InvalidMove
        display.display_invalid_move_message
      end
    end while game_is_ongoing
    display_board

    winner_of_game
  end

  def game_is_ongoing
    board.is_completed? == false
  end

  def display_board
    display.display_board(board)
  end

  def place_move_of(player)
    move = player.next_move(board)
    board.set_move(move, player.mark)
  end

  def switch_players
    players.reverse!
  end

  def winner_of_game
    if board.winner?(players.first.mark)
      players.first.mark
    elsif board.winner?(players.last.mark)
      players.last.mark
    else
      ''
    end
  end

  class InsufficientNumberOfPlayers < RuntimeError
  end

  private

  def ensure_enough_players
    if players.length != 2
      raise InsufficientNumberOfPlayers
    end
  end
end
