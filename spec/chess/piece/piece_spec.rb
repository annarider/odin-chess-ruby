# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Chess Piece class

describe Chess::Piece do
  let(:white_position) { Chess::Position.new(6, 0) }
  let(:new_piece) { described_class.new(white_position, color: :white) }
  describe '#color' do
    context 'when initializing to an allowed color' do
      it 'allows creating a new white piece' do
        expect(new_piece).to be_a(described_class)
        expect(new_piece.color).to eq(:white)
      end
      it 'allows creating a new black piece' do
        black_position = Chess::Position.new(1, 0)
        black_piece = described_class.new(black_position, color: :black)
        expect(black_piece).to be_a(described_class)
        expect(black_piece.color).to eq(:black)
      end
      it 'fails to create a green piece' do
        expect { described_class.new(white_position, color: :green) }.to raise_error(ArgumentError)
      end
    end
  end
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
