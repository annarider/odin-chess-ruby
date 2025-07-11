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
        expect(start_board.at(second_rank, a_file)).to eq('P')
      end

      it 'adds white rooks' do
        expect(start_board.at(first_rank, a_file)).to eq('R')
        expect(start_board.at(first_rank, h_file)).to eq('R')
      end

      it 'adds white king' do
        expect(start_board.at(first_rank, e_file)).to eq('K')
      end

      it 'adds black pawns to the 7th rank (row)' do
        expect(start_board.at(seventh_rank, a_file)).to eq('p')
      end

      it 'adds black king' do
        expect(start_board.at(eighth_rank, e_file)).to eq('k')
      end

      it 'adds a black bishop' do
        expect(start_board.at(eighth_rank, c_file)).to eq('b')
      end
    end
  end

  describe '#extract_grid_pieces_for_display' do
    context 'when board needs to extract game board for public consumption' do
      it 'returns a string with the number of lines as the grid board' do
        result = start_board.extract_grid_and_pieces
        expect(result).to be_an(Array)
        expect(result.size).to eq(Chess::Config::GRID_LENGTH)
      end
    end
  end
end
