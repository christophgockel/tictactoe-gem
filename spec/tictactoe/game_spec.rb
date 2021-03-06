require 'tictactoe/spec_helper'

require 'tictactoe/game'
require 'tictactoe/board'
require 'tictactoe/fake_player'

describe TicTacToe::Game do
  let(:player_one) { TicTacToe::FakePlayer.new('a', 1) }
  let(:player_two) { TicTacToe::FakePlayer.new('b', 2) }
  let(:board)      { board_with('         ') }
  let(:display)    { FakeIO.new }
  let(:game)       { described_class.new(player_one, player_two, board, display) }

  context 'rules' do
    it 'switches players for each round' do
      game = game_with_board('         ')

      game.play_next_round
      game.play_next_round

      expect(player_one.next_move_has_been_called).to be_truthy
      expect(player_two.next_move_has_been_called).to be_truthy
    end

    it 'can only be played until its over' do
      game = game_with_board('aabababba')

      expect { game.play_next_round }.to raise_error(TicTacToe::Game::Over)
    end

    it 'is playable as long as it is ongoing' do
      expect(game.is_playable?).to eq true
    end

    it 'is playable until a player is not ready anymore' do
      allow(player_one).to receive(:ready?).and_return(false)
      expect(game.is_playable?).to eq false
    end
  end

  context 'end results' do
    it 'can return the winner of a game' do
      game = game_with_board('aaa      ')

      expect(game.is_ongoing?).to eq false
      expect(game.winner).to eq 'a'
    end

    it 'returns empty string when there is no winner' do
      game = game_with_board('ababcbaba')

      expect(game.is_ongoing?).to eq false
      expect(game.winner).to eq ''
    end
  end

  context 'player interaction' do
    it 'in each round a player will be asked for its next move' do
      player_one = TicTacToe::FakePlayer.new('a', 5)

      game = described_class.new(player_one, player_two, board_with('baba bbaa'), display)
      game.play_next_round

      expect(player_one.next_move_has_been_called).to be_truthy
    end

    it 'passes the board when asking a player for a move' do
      game.play_next_round

      expect(player_one.passed_board).to eq board
    end

    it 'places player moves on board' do
      expect(board).to receive(:set_move).with(1, player_one.mark)

      game.play_next_round
    end

    it 'can be asked whether the round could be played' do
      player_one = TicTacToe::FakePlayer.new('a', 5)
      game = described_class.new(player_one, player_two, board_with('baba bbaa'), display)
      game.play_next_round

      expect(game.round_could_be_played).to eq true
    end

    context 'player not ready' do
      let(:player_one) { TicTacToe::FakePlayer.new('a', 5) }
      let(:game) { described_class.new(player_one, player_two, board_with('         '), display) }

      before :each do
        allow(player_one).to receive(:ready?).and_return(false)
      end

      it 'does not play a round when next player is not ready' do
        game.play_next_round
        expect(game.round_could_be_played).to eq false
      end

      it 'is still ongoing when a player is not ready yet' do
        game.play_next_round
        expect(game.is_ongoing?).to eq true
      end

      it 'is not ready anymore when a player is not ready' do
        game.play_next_round
        expect(game.is_ready?).to eq false
      end
    end
  end

  context 'uses a display to interact with the outside world' do
    it 'displays the board when creating a game' do
      expect(display).to receive(:show_board)

      described_class.new(player_one, player_two, board, display)
    end

    it 'displays the board after every game round' do
      expect(display).to receive(:show_board).at_least(2).times

      game.play_next_round
      game.play_next_round
    end

    it 'announces the next player when creating a game' do
      expect(display).to receive(:announce_next_player).with(player_one.mark)
      described_class.new(player_one, player_two, board, display)
    end

    it 'announces the next player after each round' do
      allow(display).to receive(:announce_next_player)

      game.play_next_round

      expect(display).to have_received(:announce_next_player).with(player_two.mark)
    end

    it 'does not announce a next player when the game is over' do
      game = described_class.new(player_one, player_two, board_with(' bababbba'), display)

      expect(display).to_not receive(:announce_next_player)
      game.play_next_round
    end

    it 'announces the winner when there is one' do
      game = described_class.new(player_one, player_two, board_with(' baabaaab'), display)

      expect(display).to receive(:announce_winner).with('a')
      game.play_next_round
    end

    it 'announces a draw' do
      game = described_class.new(player_one, player_two, board_with(' babbaaab'), display)

      expect(display).to receive(:announce_draw)
      game.play_next_round
    end

    it 'displays a message on invalid moves' do
      game = described_class.new(player_one, player_two, board_with('b        '), display)

      expect(display).to receive(:show_invalid_move_message)
      game.play_next_round
    end
  end

  context 'creating new games' do
    it 'knows what game modes are available' do
      expect(described_class.available_modes).to eq([
        :human_human,
        :human_computer,
        :computer_human,
        :computer_computer
      ])
    end
  end

  context 'FakeDisplay' do
    subject { FakeIO.new }
    it_should_behave_like 'a game io object'
  end

  def game_with_board(board_state)
    described_class.new(player_one, player_two, board_with(board_state), display)
  end

  class FakeIO
    def show_board(board)
    end

    def show_invalid_move_message
    end

    def announce_next_player(mark)
    end

    def announce_winner(mark)
    end

    def announce_draw
    end

    def next_move
    end

    def can_provide_next_move?
    end
  end
end
