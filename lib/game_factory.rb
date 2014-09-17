require 'game'
require 'board'
require 'human_player'
require 'computer_player'
require 'delayed_computer_player'

class GameFactory
  class UnknownGameType < RuntimeError
  end

  class << self; attr_accessor :human_player_class end
  @human_player_class = HumanPlayer

  def self.create_game(type, board_size = :board_3x3, display)
    if board_size == :board_4x4
      board = Board.new(4)
    else
      board = Board.new(3)
    end

    if type == :human_computer
      Game.new(human_player_class.new('x'), ComputerPlayer.new('o', 'x'), board, display)
    elsif type == :human_human
      Game.new(human_player_class.new('x'), human_player_class.new('o'), board, display)
    elsif type == :computer_human
      Game.new(ComputerPlayer.new('x', 'o'), human_player_class.new('o'), board, display)
    elsif type == :computer_computer
      player_one = DelayedComputerPlayer.new(ComputerPlayer.new('x', 'o'))
      player_two = DelayedComputerPlayer.new(ComputerPlayer.new('o', 'x'))

      Game.new(player_one, player_two, board, display)
    else
      raise UnknownGameType.new
    end
  end

  def self.available_board_sizes
    {
      :board_3x3 => '3x3',
      :board_4x4 => '4x4'
    }
  end

  def self.available_game_types
    [
      :human_human,
      :human_computer,
      :computer_human,
      :computer_computer
    ]
  end
end
