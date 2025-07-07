# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Position class

describe Chess::Position do
  subject(:test_position) { described_class }

  let(:top_left_position) { described_class.new(0, 0) }
  let(:top_right_position) { described_class.new(0, 7) }
  let(:bottom_left_position) { described_class.new(7, 0) }
  let(:bottom_right_position) { described_class.new(7, 7) }

  describe 'class methods' do
    describe '.from_numeric' do
      context 'when passing in the topmost leftmost square' do
        it 'returns the position using array index coordinates' do
          result = described_class.from_numeric(0, 0)
          expect(result).to eq([0, 0])
        end
      end

      context 'when passing in the bottom rightmost square' do
        it 'returns the position using array index coordinates' do
          result = described_class.from_numeric(7, 7)
          expect(result).to eq([7, 7])
        end
      end
    end
  end

  describe 'instance methods' do
    describe '#==' do
      it 'returns true when the positions are the same' do
        test_position = described_class.new(0, 0)
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
          test_position = described_class.new(3, 4)
          result = test_position.in_bound?
          expect(result).to be true
        end
      end

      context 'when the coordinates are outside the game board' do
        it 'returns false for a negative coordinate' do
          test_position = described_class.new(-1, 0)
          result = test_position.in_bound?
          expect(result).to be false
        end

        it 'returns false for a big index' do
          test_position = described_class.new(0, 99)
          result = test_position.in_bound?
          expect(result).to be false
        end
      end
    end

    describe '#transform_coordinates' do
      context 'when the white pawn is at starting position' do
        it 'returns the position 1 square up' do
          start_position = described_class.new(6, 0)
          delta_position = described_class.new(-1, 0)
          result = start_position.transform_coordinates(delta_position)
          expect(result).to eq(described_class.new(5, 0))
        end

        it 'returns the position 2 squares up' do
          start_position = described_class.new(6, 1)
          delta_position = described_class.new(-2, 0)
          result = start_position.transform_coordinates(delta_position)
          expect(result).to eq(described_class.new(4, 1))
        end
      end
    end
  end
end
