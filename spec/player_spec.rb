require 'rspec'

require 'player'


describe Player do
  let(:dummy_board) { double }

  it "has a symbol" do
    player = Player.new("X")
    expect(player.symbol).to eq "X"
  end

  it "asks an input object to get its next move" do
    input = double("Input", :next_move => 42)
    player = Player.new("X", input)
    player.next_move(dummy_board)

    expect(input).to have_received(:next_move).with(player, dummy_board)
  end

  it "returns a Move when asked for it" do
    input = double("Input", :next_move => 6)
    player = Player.new("X", input)
    move = player.next_move(dummy_board)

    expect(move.symbol).to eq "X"
    expect(move.location).to eq 6
  end

  it 'has factory methods for creating a specific player' do
    expect(Player.X.symbol).to eq Player::X
    expect(Player.O.symbol).to eq Player::O
  end
end