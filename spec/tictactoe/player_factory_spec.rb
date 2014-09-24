require 'tictactoe/human_player'
require 'tictactoe/computer_player'
require 'tictactoe/delayed_computer_player'
require 'tictactoe/player_factory'

describe TicTacToe::PlayerFactory do
  let(:display) { double.as_null_object }

  it 'supports human vs. computer' do
    players = described_class.create_pair(:human_computer, display)

    expect(players.first).to be_a_kind_of TicTacToe::HumanPlayer
    expect(players.last).to be_a_kind_of TicTacToe::ComputerPlayer
  end

  it 'supports human vs. human' do
    players = described_class.create_pair(:human_human, display)

    expect(players.first).to be_a_kind_of TicTacToe::HumanPlayer
    expect(players.last).to be_a_kind_of TicTacToe::HumanPlayer
  end

  it 'supports computer vs. human' do
    players = described_class.create_pair(:computer_human, display)

    expect(players.first).to be_a_kind_of TicTacToe::ComputerPlayer
    expect(players.last).to be_a_kind_of TicTacToe::HumanPlayer
  end

  it 'supports computer vs. computer' do
    players = described_class.create_pair(:computer_computer, display)

    expect(players.first).to be_a_kind_of TicTacToe::DelayedComputerPlayer
    expect(players.last).to be_a_kind_of TicTacToe::DelayedComputerPlayer
  end

  it 'throws exception for unknown pair types' do
    expect {
      described_class.create_pair(:unknown_pair_type, display)
    }.to raise_error TicTacToe::PlayerFactory::UnknownPair
  end

  it 'returns information about what player pairs are possible' do
    expect(TicTacToe::PlayerFactory.available_player_pairs).to eq([
      :human_human,
      :human_computer,
      :computer_human,
      :computer_computer
    ])
  end
end
