# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Chess Pawn class

describe Chess::Pawn do
  let(:white_pawn) { described_class.new(Chess::Position.new(6, 0)) }
  describe '#moved?' do
    context 'when starting a new game and pawn has not moved' do
      it 'returns false thanks to inheriting from piece superclass' do
        result = white_pawn.moved?
        expect(result).to be false
      end
    end
  end

  describe '#mark_as_moved!' do
    context 'after the pawn has moved' do
      it 'shows moved? status as true to reflect new move status' do
        white_pawn.mark_as_moved!
        expect(white_pawn).to be_moved
      end
    end
  end

  describe '#move' do
    context 'when starting a new game and pawn moves 1 space up' do
      it 'returns the new position after the leftmost white pawn moved' do
        new_position = white_pawn.move
        expect(new_position).to eq(Chess::Position.new(5, 0))
        expect(white_pawn.position).to eq(new_position)
      end
      it 'returns the new position after the leftmost black pawn moved' do
        black_pawn = described_class.new(Chess::Position.new(1, 0), color: :black)
        new_position = black_pawn.move
        expect(new_position).to eq(Chess::Position.new(2, 0))
        expect(black_pawn.position).to eq(new_position)
      end

      it 'returns the new position after the rightmost black pawn' do
        black_pawn = described_class.new(Chess::Position.new(1, 7), color: :black)
        new_position = black_pawn.move
        expect(new_position).to eq(Chess::Position.new(2, 7))
        expect(black_pawn.position).to eq(new_position)
      end
    end

    context 'when starting a new game and pawn moves 2 squares up' do
      it 'returns the new position after middle white pawn moved' do
        new_position = white_pawn.move(2)
        expect(new_position).to eq(Chess::Position.new(4, 0))
        expect(white_pawn.move(2)).to eq(new_position)
      end
    end
  end
end
