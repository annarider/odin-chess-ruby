# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for Move History class

describe Chess::MoveHistory do
  subject(:move_history) { described_class.new }

  describe '#add_move' do
    context 'when the first move completes' do
      let(:knight_start) { Chess::Position.from_algebraic('b1') }
      let(:knight_destination) { Chess::Position.from_algebraic('c3') }
      let(:move) { Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N') }
      it 'returns the first move' do
        result = move_history.add_move(move)
        expect(result).to eq([move])
      end
      it 'returns the hash key of the first move' do
        
      end
    end
  end
end
