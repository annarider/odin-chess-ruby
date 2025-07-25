# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Chess Pawn class

describe Chess::Pawn do
  let(:leftmost_white_pawn) do
    described_class.new(Chess::Position.new(6, 0))
  end
  let(:leftmost_black_pawn) do
    described_class.new(Chess::Position.new(1, 0), color: :black)
  end
  let(:rightmost_black_pawn) do
    described_class.new(Chess::Position.new(1, 7), color: :black)
  end
  let(:middle_black_pawn) do
    described_class.new(Chess::Position.new(1, 3), color: :black)
  end
  let(:already_moved_pawn) do
    described_class.new(Chess::Position.new(2, 1), color: :black, moved: true)
  end

  describe '#moved?' do
    context 'when starting a new game and pawn has not moved' do
      it 'returns false thanks to inheriting from piece superclass' do
        result = leftmost_white_pawn.moved?
        expect(result).to be false
      end
    end
  end

  describe '#mark_as_moved!' do
    context 'when the pawn has moved' do
      it 'shows moved? status as true to reflect new move status' do
        leftmost_white_pawn.mark_as_moved!
        expect(leftmost_white_pawn).to be_moved
      end
    end
  end

  describe '#move' do
    context 'when the pawn is moving straight' do
      context 'when starting a new game and pawn moves 1 space up' do
        it 'returns the new position after the leftmost white pawn moved' do
          new_position = leftmost_white_pawn.move(:forward_one)
          expect(new_position).to eq(Chess::Position.new(5, 0))
          expect(leftmost_white_pawn.position).to eq(new_position)
        end

        it 'returns the new position after the leftmost black pawn moved' do
          new_position = leftmost_black_pawn.move(:forward_one)
          expect(new_position).to eq(Chess::Position.new(2, 0))
          expect(leftmost_black_pawn.position).to eq(new_position)
        end

        it 'returns the new position after the rightmost black pawn' do
          new_position = rightmost_black_pawn.move(:forward_one)
          expect(new_position).to eq(Chess::Position.new(2, 7))
          expect(rightmost_black_pawn.position).to eq(new_position)
        end
      end

      context 'when starting a new game and pawn moves 2 squares up' do
        it 'returns the new position after middle white pawn moved' do
          new_position = leftmost_white_pawn.move(:forward_two)
          expect(new_position).to eq(Chess::Position.new(4, 0))
          expect(leftmost_white_pawn.position).to eq(new_position)
        end

        it 'returns the new position after middle black pawn moved' do
          new_position = middle_black_pawn.move(:forward_two)
          expect(new_position).to eq(Chess::Position.new(3, 3))
          expect(middle_black_pawn.position).to eq(new_position)
        end
      end
    end

    context 'when the pawn is moving diagonally to capture' do
      context 'when the white pawn moves 1 up diagonal left square' do
        it 'returns an error when the leftmost white pawn tries to move' do
          expect { leftmost_white_pawn.move(:diagonal_left) }.to raise_error(Chess::OutOfBoundsError)
        end

        it 'returns the new position when the leftmost white moves diagonally right' do
          new_position = leftmost_white_pawn.move(:diagonal_right)
          expect(new_position).to eq(Chess::Position.new(5, 1))
        end
      end

      context 'when the middle black pawn moves diagonally to capture' do
        it 'returns the new position' do
          new_position = middle_black_pawn.move(:diagonal_left)
          expect(new_position).to eq(Chess::Position.new(2, 4))
        end
      end
    end

    context 'when the rightmost black pawn moves diagonally to capture' do
      it 'returns an error when rightmost black pawn moves diagonally left' do
        expect { rightmost_black_pawn.move(:diagonal_left) }.to raise_error(Chess::OutOfBoundsError)
      end
    end

    context 'when the pawn has already moved and tries to advance 2 squares' do
      it 'returns an error' do
        expect { already_moved_pawn.move(:forward_two) }.to raise_error(Chess::Pawn::InvalidMove)
      end
    end
  end
end
