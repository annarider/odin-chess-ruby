# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Connect Four Piece class

describe Chess::Piece do
  let(:new_piece) { described_class.new }
  describe '#moved' do
    context 'when the game starts and the piece has not moved' do
      it 'returns false' do
        result = new_piece.moved?
        expect(result).to be false
      end
    end
  end
  describe '#mark_as_moved!' do
    context 'after a piece has moved' do
      it 'changes the moved flag from false to true' do
        expect { new_piece.mark_as_moved! }
        .to change { new_piece.moved? }
        .from(false).to(true)
      end
    end
  end
end
