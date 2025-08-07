# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Chess Game class

describe Chess::Game do
  let(:start_game) { described_class.new }
  let(:end_game) { described_class.new }
  
  describe '.from_fen' do
    context 'when creating a new game from start positions' do
      let(:starting_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it "returns that it is white's turn to move" do
        result = start_game.active_color
        expect(result).to eq('w')
      end

      it 'returns 0 for half move clock' do
        expect(start_game.half_move_clock).to eq(0)
      end

      it 'returns 1 for full move number' do
        expect(start_game.full_move_number).to eq(1)
      end
    end

    context 'when loading a midway game from fen' do
      subject(:midway_game) { described_class.from_fen(after_move_fen) }

      let(:after_move_fen) { 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1' }

      it 'returns active player color is black' do
        expect(midway_game.active_color).to eq('b')
      end

      it 'returns 0 for half move clock' do
        expect(midway_game.half_move_clock).to eq(0)
      end

      it 'returns 1 for full move number' do
        expect(midway_game.full_move_number).to eq(1)
      end
    end

    context 'when loading an end game from fen' do
      subject(:end_game) { described_class.from_fen(end_game_fen) }

      let(:end_game_fen) { '3B4/K7/2k1b1p1/1p2Pp1p/3P3P/2P3P1/8/8 w - - 0 74' }

      it 'returns active player color is white' do
        expect(end_game.active_color).to eq('w')
      end

      it 'returns 0 for half move clock' do
        expect(end_game.half_move_clock).to eq(0)
      end

      it 'returns 74 for full move number' do
        expect(end_game.full_move_number).to eq(74)
      end
    end
  end

  describe '#to_fen' do
    context 'when starting a new game' do
      it 'returns the fen piece placement data in the correct order' do
        result = start_game.to_fen
        starting_fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
        expect(result).to eq(starting_fen)
      end
    end

    context 'when creating FEN from a midway game' do
      subject(:midway_game) { described_class.from_fen(mid_game_fen) }

      let(:mid_game_fen) { 'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2' }

      it 'returns the same FEN as loaded in' do
        result = midway_game.to_fen
        expect(result).to eq(mid_game_fen)
      end
    end

    context 'when creating FEN from end game' do
      subject(:end_game) { described_class.from_fen(end_game_fen) }

      let(:end_game_fen) { '3b2k1/1p3p2/p1p5/2P4p/1P2P1p1/5p2/5P2/4RK2 w - - 0 0' }

      it 'returns the same FEN as loaded in' do
        result = end_game.to_fen
        expect(result).to eq(end_game_fen)
      end
    end

    context 'when creating FEN from Fischer vs Byrne, 1956 game after queen sacrifice' do
      subject(:game_of_the_century) { described_class.from_fen(game_of_the_century_fen) }

      let(:game_of_the_century_fen) { 'r3r1k1/pp3ppp/1qn2n2/3p1b2/3P1B2/2N2N2/PP2QPPP/2RR2K1 b - - 0 18' }

      it 'results in same FEN as loaded in' do
        result = game_of_the_century.to_fen
        expect(result).to eq(game_of_the_century_fen)
      end
    end
  end

  describe '#play' do
    before do
      allow(Chess::Interface).to receive(:welcome)
      allow(Chess::Display).to receive(:show_board)
      allow(start_game).to receive(:puts)
    end
    context 'when game starts and ends immediately' do
      before do 
        allow(start_game).to receive(:play_turn) do
          start_game.instance_variable_set(:@game_over, true)
        end
      end
      it 'calls start' do
        expect(start_game).to receive(:start)
        start_game.play
      end
      it 'calls announce_game_end' do
        expect(start_game).to receive(:announce_game_end)
        start_game.play
      end
    end
  end
  describe '#start' do
    context 'when starting the game from initial positions' do
      subject(:new_game) { described_class.from_fen(starting_fen) }
      let(:starting_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
let(:mock_board_data) do
        [
          ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'],
          ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
          ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']
        ]
      end
      it 'returns white as the active player color' do
        current_player = new_game.active_color
        expect(current_player).to eq('w')
      end

      it 'returns starting position fen string' do
        result = new_game.to_fen
        expect(result).to eq(starting_fen)
      end
      it 'sends a welcome message' do
        allow(Chess::Display).to receive(:show_board)
        allow(Chess::Interface).to receive(:welcome)
        expect(Chess::Interface).to receive(:welcome)
        new_game.start
      end
      it 'displays the board' do
        allow(Chess::Interface).to receive(:welcome)
        board_mock = instance_double(Chess::Board)
        allow(board_mock).to receive(:to_display).and_return(mock_board_data)
        game = described_class.new(board: board_mock)
        expect(Chess::Display).to receive(:show_board).with(mock_board_data)
        game.start
      end
    end
  end

  describe '#switch_turn' do
    context 'after white makes a move' do
      it 'sends a message to switch to black' do
        expect {start_game.switch_turn}.to change {start_game.active_color}.
          from('w').to ('b')
        start_game.switch_turn
      end
    end
  end

  describe '#game_over?' do
    context 'when the game just started' do
      it 'returns false' do
        expect(start_game.game_over?).to be false
      end
    end
    context 'when checkmate? is true' do
      it 'returns true' do
        allow(end_game).to receive(:checkmate?).and_return(true)
        expect(end_game).to be_game_over
      end
    end
    context 'when draw by rule is true' do
      it 'returns true' do
        allow(end_game).to receive(:draw_by_rule?).and_return(true)
        expect(end_game).to be_game_over
      end
    end
  end
  describe '#winner' do
    context 'when game is not over' do
      it 'returns nil' do
        expect(start_game.winner).to be_nil
      end
    end
    context 'when black checkmates' do
      it 'returns black as the winner' do
        allow(end_game).to receive(:game_over?).and_return(true)
        expect(end_game.winner).to eq('b')
      end
    end
  end
end
