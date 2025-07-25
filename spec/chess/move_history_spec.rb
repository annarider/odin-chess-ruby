# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for Move History class

describe Chess::MoveHistory do
  subject(:history_from_start) { described_class.new }

  describe '#add_move' do
    context 'when the first move completes' do
      let(:knight_start) { Chess::Position.from_algebraic('b1') }
      let(:knight_destination) { Chess::Position.from_algebraic('c3') }
      let(:move) { Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N') }

      it 'increases the move count by 1' do
        expect { history_from_start.add_move(move) }.to change(history_from_start, :move_count).by(1)
      end

      it 'increase the position hash by 1' do
        expect { history_from_start.add_move(move) }.to(change(history_from_start, :move))
      end
    end
  end
end
