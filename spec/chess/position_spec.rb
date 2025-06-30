# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Position class

describe Chess::Position do
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
    subject(:test_position) { described_class }
    describe '#==' do
      it 'returns true when the positions are the same' do
        top_left_position = described_class.new(0, 0)
        test_position = described_class.new(0, 0)
        result = top_left_position == test_position
        expect(result).to be true
      end

      it 'returns false when the positions are not the same' do
        top_left_position = described_class.new(0, 0)
        test_position = described_class.new(7, 7)
        result = top_left_position == test_position
        expect(result).to be false
      end
    end
  end
end
