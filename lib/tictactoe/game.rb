require 'tictactoe/board'

module TicTacToe
  class Game
    attr_reader :players, :board, :display, :round_could_be_played

    class Over < RuntimeError
    end

    def self.available_modes
      [
        :human_human,
        :human_computer,
        :computer_human,
        :computer_computer
      ]
    end

    def initialize(player_one, player_two, board = nil, display = nil)
      @players = [player_one, player_two]
      @board   = board || Board.new
      @display = display
      @round_could_be_played = false

      update_display
    end

    def play_next_round
      raise Over if is_ongoing? == false

      if next_player.ready?
        place_move_of(next_player)
        switch_players
        update_display
        @round_could_be_played = true
      else
        @round_could_be_played = false
      end
    rescue Board::InvalidMove
      @round_could_be_played = false
      display.show_invalid_move_message
    end

    def next_player
      players.first
    end

    def is_ongoing?
      board.is_completed? == false
    end

    def is_ready?
      next_player.ready?
    end

    def is_playable?
      is_ongoing? && is_ready?
    end

    def winner
      return players.first.mark if board.winner?(players.first.mark)
      return players.last.mark  if board.winner?(players.last.mark)
      ''
    end

    private

    def place_move_of(player)
      move = player.next_move(board)
      board.set_move(move, player.mark)
    end

    def switch_players
      players.reverse!
    end

    def update_display
      display.show_board(board)

      if is_ongoing?
        display.announce_next_player(players.first.mark)
      elsif winner != ''
        display.announce_winner(winner)
      else
        display.announce_draw
      end
    end
  end
end
