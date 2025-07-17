# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Board class

describe Chess::Board do
  subject(:start_board) { described_class.initial_start }

  let(:first_rank) { 7 }
  let(:second_rank) { 6 }
  let(:seventh_rank) { 1 }
  let(:eighth_rank) { 0 }
  let(:a_file) { 0 }
  let(:c_file) { 2 }
  let(:e_file) { 4 }
  let(:h_file) { 7 }

  describe '.initial_start' do
    context 'when the board is created' do
      it 'adds white pawns to the second rank (row)' do
        p start_board
        initial_position = Chess::Position.from_algebraic('a2')
        expect(start_board.piece_at(initial_position)).to eq('P')
      end

      it 'adds white rooks' do
        initial_pos_queenside = Chess::Position.from_coordinates(first_rank, a_file)
        initial_pos_kingside = Chess::Position.from_coordinates(first_rank, h_file)
        expect(start_board.piece_at(initial_pos_queenside)).to eq('R')
        expect(start_board.piece_at(initial_pos_kingside)).to eq('R')
      end

      it 'adds white king' do
        initial_position = Chess::Position.from_coordinates(first_rank, e_file)
        expect(start_board.piece_at(initial_position)).to eq('K')
      end

      it 'adds black pawns to the 7th rank (row)' do
        initial_position = Chess::Position.from_algebraic('a7')
        expect(start_board.piece_at(initial_position)).to eq('p')
      end

      it 'adds black king' do
        initial_position = Chess::Position.from_coordinates(eighth_rank, e_file)
        expect(start_board.piece_at(initial_position)).to eq('k')
      end

      it 'adds a black bishop' do
        initial_position = Chess::Position.from_coordinates(eighth_rank, c_file)
        expect(start_board.piece_at(initial_position)).to eq('b')
      end

      it 'returns white as the active player color' do
        current_player = start_board.active_color
        expect(current_player).to eq('w')
      end
    end
  end

  describe '#to_display' do
    context 'when starting a new game' do
      it 'returns a display string with the same number of lines as the grid board' do
        result = start_board.to_display
        expect(result).to be_an(Array)
        expect(result.size).to eq(Chess::Config::GRID_LENGTH)
      end
    end
  end

  describe '#to_fen' do
    context 'when starting a new game' do
      it 'returns the fen piece placement data in the correct order' do
        result = start_board.to_fen
        starting_fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq '
        expect(result).to eq(starting_fen)
      end
    end
  end
end
