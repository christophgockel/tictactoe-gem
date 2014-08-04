require 'game'
require 'human_player'
require 'computer_player'
require 'delayed_computer_player'

class GameFactory
  class << self; attr_accessor :human_player_class end
  @human_player_class = HumanPlayer

  def self.create_game(type)
    if type == :human_vs_computer
      Game.new(human_player_class.new('x'), ComputerPlayer.new('o', 'x'))
    elsif type == :human_vs_human
      Game.new(human_player_class.new('x'), human_player_class.new('o'))
    elsif type == :computer_vs_human
      Game.new(ComputerPlayer.new('x', 'o'), human_player_class.new('o'))
    elsif type == :computer_vs_computer
      player_one = DelayedComputerPlayer.new(ComputerPlayer.new('x', 'o'))
      player_two = DelayedComputerPlayer.new(ComputerPlayer.new('o', 'x'))

      Game.new(player_one, player_two)
    end
  end
end
