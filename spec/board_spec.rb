# frozen_string_literal: true

require_relative '../lib/board'

# Tests for the Chess Board class

describe Chess::Board do
  let(:first_rank) { 7 }
  let(:second_rank) { 6 }
  let(:seventh_rank) { 1 }
  let(:new_game) { described_class.new }
  describe '#set_up_pieces' do
    context 'when the board is created' do
      it 'adds dark pawns to the second rank (row)' do
        expect { new_game.set_up_pieces }.to change {
          new_game.grid[second_rank][0]
      }.from(nil).to('DP')
      end

      it 'adds light pawns to the 7th rank (row)' do
        expect { new_game.set_up_pieces }.to change {
          new_game.grid[seventh_rank][0]
      }.from(nil).to('LP')
      end
    end
  end
end
