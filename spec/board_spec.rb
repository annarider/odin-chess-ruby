# frozen_string_literal: true

require_relative '../lib/board'

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
  let(:new_game) { described_class.new }
  describe '#set_up_pieces' do
    context 'when the board is created' do
      it 'adds white pawns to the second rank (row)' do
        expect { new_game.set_up_pieces }
          .to change { new_game.grid[second_rank][a_file] }.from(nil).to('WP')
      end
      it 'adds white rooks' do
        expect { new_game.set_up_pieces }
          .to change { new_game.grid[first_rank][a_file] }.from(nil).to('WR')
          .and change { new_game.grid[first_rank][h_file] }.from(nil).to('WR')
      end
      it 'adds white king' do
        expect { new_game.set_up_pieces }
          .to change { new_game.grid[first_rank][e_file]}.from(nil).to('WK')
      end
      it 'adds black pawns to the 7th rank (row)' do
        expect { new_game.set_up_pieces }
        .to change { new_game.grid[seventh_rank][a_file] }.from(nil).to('BP')
      end
      it 'adds black king' do
        expect { new_game.set_up_pieces }
          .to change { new_game.grid[eighth_rank][e_file]}.from(nil).to('BK')
      end
      it 'adds a black bishop' do
        expect { new_game.set_up_pieces }
          .to change { new_game.grid[eighth_rank][c_file]}.from(nil).to('BB')
      end
    end
  end
end
