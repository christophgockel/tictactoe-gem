require 'tictactoe/human_player'
require 'tictactoe/computer_player'
require 'tictactoe/delayed_computer_player'

module TicTacToe
  class PlayerFactory
    class UnknownPair < RuntimeError
    end

    def self.create_pair(mode, display)
      case mode
      when :human_computer
        [
          HumanPlayer.new('x', display),
          ComputerPlayer.new('o', 'x')
        ]
      when :human_human
        [
          HumanPlayer.new('x', display),
          HumanPlayer.new('o', display)
        ]
      when :computer_human
        [
          ComputerPlayer.new('x', 'o'),
          HumanPlayer.new('o', display)
        ]
      when :computer_computer
        [
          DelayedComputerPlayer.new(ComputerPlayer.new('x', 'o')),
          DelayedComputerPlayer.new(ComputerPlayer.new('o', 'x'))
        ]
      else
        raise UnknownPair.new
      end
    end

    def self.available_player_pairs
      [
        :human_human,
        :human_computer,
        :computer_human,
        :computer_computer
      ]
    end
  end
end
