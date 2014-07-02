require 'rspec'

require 'board'


describe Board do
  it 'is empty when just created' do
    board = Board.new
    expect(board.empty?).to be true
  end

  it 'is not empty when it got a move placed' do
    board = Board.new
    board.set(some_move)

    expect(board.empty?).to be false
  end

  it 'can return its rows' do
    board = board_with('111222333')
    
    expect(board.rows).to eq [['1', '1', '1'], ['2', '2', '2'], ['3', '3', '3']]
  end

  it 'can return its columns' do
    board = board_with('123123123')
    expect(board.columns).to eq [['1', '1', '1'], ['2', '2', '2'], ['3', '3', '3']]
  end


  def some_move
    Move.new('x', 0)
  end

  def board_with(contents)
    board = Board.new

    contents.split('').each_with_index do |symbol, index|
      board.set(Move.new(symbol, index))
    end

    board
  end
end
