# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Move class

describe Chess::Move do
  describe '#possible_moves' do
  context 'when white knight from b1 moves from starting game positions' do
    subject(:knight_move) { described_class.new(from_position: start_pos, to_position: destination, piece:'N') }
    let(:start_pos) { Chess::Position.from_algebraic('b1') }
    let(:destination) { Chess::Position.from_algebraic('c3') }
      it 'returns an array with 2 moves' do
        expect(knight_move.possible_moves.length).to be(2)
      end
      it 'returns the destination move of c3' do
        expect(knight_move.possible_moves).to include(destination)
      end
      it 'returns the alternative destination of a3' do
        alt_destination = Chess::Position.from_algebraic('a3')
        expect(knight_move.possible_moves).to include(alt_destination)
      end
    end
  end
end
