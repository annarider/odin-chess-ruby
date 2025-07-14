# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Piece class

describe Chess::Piece do
  describe '#color' do
    subject(:white_pawn) { described_class.new(:pawn, :white) }

    context 'when making a new white pawn' do
      it 'returns the color white' do
        expect(white_pawn.color).to eq(:white)
      end
    end

    context 'when making a black rook' do
      it 'allows creating a new black rook' do
        black_rook = described_class.new(:rook, :black)
        expect(black_rook).to be_a(described_class)
        expect(black_rook.color).to eq(:black)
      end
    end

    context 'when creating a green king' do
      it 'fails to create a green king' do
        expect { described_class.new(:king, :green) }.to raise_error(ArgumentError)
      end
    end
  end
end
