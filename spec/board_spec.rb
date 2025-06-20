# frozen_string_literal: true

require_relative '../lib/board'

# Tests for the Chess Board class

describe Chess::Board do
  let(:first_rank) { 7 }
  let(:second_rank) { 6 }
  let(:seventh_rank) { 1 }
  let(:first_file) { 0 }
  let(:last_file) { 7 }
  let(:new_game) { described_class.new }
  describe '#set_up_pieces' do
    context 'when the board is created' do
      it 'adds light pawns to the second rank (row)' do
        expect { new_game.set_up_pieces }.to change {
          new_game.grid[second_rank][first_file]
      }.from(nil).to('LP')
      end
      it 'adds light rooks' do
        expect{ new_game.set_up_pieces }
        .to change { new_game.grid[first_rank][first_file] }.from(nil).to('LR')
        .and change { new_game.grid[first_rank][last_file] }.from(nil).to('LR')
      end

      it 'adds dark pawns to the 7th rank (row)' do
        expect { new_game.set_up_pieces }
        .to change { new_game.grid[seventh_rank][first_file] }.from(nil).to('DP')
      end
    end
  end
end
