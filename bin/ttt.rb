require 'game'
require 'human_player'
require 'computer_player'
require 'commandline_ui'



begin
  x = HumanPlayer.new('x')
  o = ComputerPlayer.new('o')

  game = Game.init(x, o)
  ui = CommandlineUI.new(game)

  ui.run
rescue Interrupt
end
