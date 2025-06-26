# frozen_string_literal: true

require_relative '../lib/chess'

# Tests for the Chess Board class

describe Chess::Board do
  let(:first_rank) { 7 }
  let(:second_rank) { 6 }
  let(:seventh_rank) { 1 }
  let(:eighth_rank) { 0 }
  let(:a_file) { 0 }
  let(:c_file) { 2 }
  let(:e_file) { 4 }
  let(:h_file) { 7 }
  subject(:new_game) { described_class.default }
  describe '#initialize' do
    context 'when the board is created' do
      it 'adds white pawns to the second rank (row)' do
        expect(new_game.grid[second_rank][a_file]).to eq('WP')
      end
      it 'adds white rooks' do
        expect(new_game.grid[first_rank][a_file]).to eq('WR')
        expect(new_game.grid[first_rank][h_file]).to eq('WR')
      end
      it 'adds white king' do
        expect(new_game.grid[first_rank][e_file]).to eq('WK')
      end
      it 'adds black pawns to the 7th rank (row)' do
        expect(new_game.grid[seventh_rank][a_file]).to eq('BP')
      end
      it 'adds black king' do
        expect(new_game.grid[eighth_rank][e_file]).to eq('BK')
      end
      it 'adds a black bishop' do
        expect(new_game.grid[eighth_rank][c_file]).to eq('BB')
      end
    end
  end

  describe '#extract_grid_pieces_for_display' do
    context 'when board needs to extract game board for public consumption' do
      it 'returns a string with the number of lines as the grid board' do
        result = new_game.extract_grid_and_pieces
        expect(result).to be_an(Array)
        expect(result.size).to eq(Chess::Config::GRID_LENGTH)
      end
    end
  end
end
