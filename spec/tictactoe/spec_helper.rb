require 'simplecov'

require 'helpers/tictactoe/board_helper'
require 'helpers/tictactoe/shared_examples'

SimpleCov.start do
    add_filter '/spec/'
end

RSpec.configure do |c|
  c.include TicTacToe::BoardHelper
end
