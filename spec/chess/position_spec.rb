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

    describe '.from_algebraic' do
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
    describe '#rank' do
      it 'returns 8 for a8, top left square, when the row is 0 index' do
        expect(top_left_position.rank).to eq('8')
      end

      it 'returns 1 for h1, bottom right square, when the row is 7 index' do
        expect(bottom_right_position.rank).to eq('1')
      end
    end

    describe '#file' do
      it 'returns a for a8, top left square, when the column is 0 index' do
        expect(top_left_position.file).to eq('a')
      end

      it 'returns h for h8, top right square, when the column is 7 index' do
        expect(top_right_position.file).to eq('h')
      end
    end

    describe 'square' do
      it 'returns a1, bottom left square, when coordinates are [0, 7]' do
        expect(bottom_left_position.square).to eq('a1')
      end

      it 'returns h1, bottom right square, when coordinates are [7, 7]' do
        expect(bottom_right_position.square).to eq('h1')
      end
    end

    describe 'coordinates' do
      it 'returns [0, 3] on square d8' do
        middle_position = described_class.from_algebraic('d8')
        expect(middle_position.coordinates).to eq([0, 3])
      end

      it 'returns [6, 7] on square h2' do
        end_position = described_class.from_algebraic('h2')
        expect(end_position.coordinates).to eq([6, 7])
      end
    end

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
          delta_1_up = described_class.from_coordinates(-1, 0)
          result = start_position.transform_coordinates(delta_1_up)
          expect(result).to eq(described_class.from_coordinates(5, 0))
        end

        it 'returns the position 2 squares up' do
          start_position = described_class.from_coordinates(6, 1)
          delta_2_up = described_class.from_coordinates(-2, 0)
          result = start_position.transform_coordinates(delta_2_up)
          expect(result).to eq(described_class.from_coordinates(4, 1))
        end
      end
    end

    describe '#+' do
      context 'when using algebraic notation' do
        it 'returns the position 1 square down' do
          start_position = described_class.from_algebraic('a8')
          delta_1_down = described_class.from_coordinates(1, 0)
          result = start_position + delta_1_down
          puts Chess::Position.instance_methods.include?(:+)
          expect(result).to eq(described_class.from_algebraic('a7'))
        end
      end
    end
  end
end
