# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Position class

describe Chess::Position do
  let(:top_left_position) { described_class.from_coordinates(0, 0) }
  let(:top_right_position) { described_class.from_coordinates(0, 7) }
  let(:bottom_left_position) { described_class.from_coordinates(7, 0) }
  let(:bottom_right_position) { described_class.from_coordinates(7, 7) }

  describe 'class methods' do
    describe '.from_coordinates' do
      context 'when passing in the topmost leftmost square' do
        it 'returns the position using array index coordinates' do
          result = top_left_position.square
          expect(result).to eq('a8')
        end
      end

      context 'when passing in the bottom rightmost square' do
        it 'returns the position using array index coordinates' do
          result = bottom_right_position.square
          expect(result).to eq('h1')
        end
      end
    end
    describe '.from_algrebraic' do
      context 'when creating a position from chess notation' do
        it 'returns the position of e4' do
          result = described_class.from_algebraic('e4')
          expect(result.coordinates).to eq([4, 4])
        end

        it 'returns the position of h8' do
          result = described_class.from_algebraic('h8')
          expect(result).to eq(top_right_position)
        end
      end
    end
  end

  describe 'instance methods' do
    describe '#==' do
      it 'returns true when the positions are the same' do
        test_position = described_class.from_coordinates(0, 0)
        result = top_left_position == test_position
        expect(result).to be true
      end

      it 'returns false when the positions are not the same' do
        result = top_left_position == bottom_right_position
        expect(result).to be false
      end
    end

    describe '#in_bound?' do
      context 'when the coordinates are inside the game board' do
        it 'returns true for top left position' do
          result = top_left_position.in_bound?
          expect(result).to be true
        end

        it 'returns true for top right position' do
          result = top_right_position.in_bound?
          expect(result).to be true
        end

        it 'returns true for bottom right position' do
          result = bottom_right_position.in_bound?
          expect(result).to be true
        end

        it 'returns true for a coordinate in the middle of the board' do
          middle_position = described_class.from_coordinates(3, 4)
          result = middle_position.in_bound?
          expect(result).to be true
        end
      end

      context 'when the coordinates are outside the game board' do
        it 'returns false for a negative coordinate' do
          invalid_position = described_class.from_coordinates(-1, 0)
          result = invalid_position.in_bound?
          expect(result).to be false
        end

        it 'returns false for a big index' do
          invalid_position = described_class.from_coordinates(0, 99)
          result = invalid_position.in_bound?
          expect(result).to be false
        end
      end
    end

    describe '#transform_coordinates' do
      context 'when the white pawn is at starting position' do
        it 'returns the position 1 square up' do
          start_position = described_class.from_coordinates(6, 0)
          delta_position = described_class.from_coordinates(-1, 0)
          result = start_position.transform_coordinates(delta_position)
          expect(result).to eq(described_class.from_coordinates(5, 0))
        end

        it 'returns the position 2 squares up' do
          start_position = described_class.from_coordinates(6, 1)
          delta_position = described_class.from_coordinates(-2, 0)
          result = start_position.transform_coordinates(delta_position)
          expect(result).to eq(described_class.from_coordinates(4, 1))
        end
      end
    end
  end
end
