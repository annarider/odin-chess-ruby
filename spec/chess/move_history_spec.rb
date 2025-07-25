# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for Move History class

describe Chess::MoveHistory do
  subject(:history_from_start) { described_class.new }

  describe '#add_move' do
    context 'when the first move completes' do
      let(:knight_start) { Chess::Position.from_algebraic('b1') }
      let(:knight_destination) { Chess::Position.from_algebraic('c3') }
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/2N5/PPPPPPPP/R1BQKBNR b KQkq - 1 1' }
      let(:knight_move) { Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N', fen: fen) }
      it 'increases the move count by 1' do
        expect { history_from_start.add_move(knight_move) }.to change(history_from_start, :count_moves).by(1)
      end

      it 'return false for threefold repetition?' do
        history_from_start.add_move(knight_move)
        result = history_from_start.threefold_repetition?
        expect(result).to be false
      end
    end
  end
  describe 'threefold_repetition?' do
    context 'when '
  end
end
