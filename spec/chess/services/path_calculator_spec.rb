# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::PathCalculator do
  subject(:calc) { described_class }

  describe '.calculate_path_between' do
    context 'when start and destination are the same position' do
      it 'returns an empty array' do
        start_pos = Chess::Position.new(4, 4)
        end_pos = Chess::Position.new(4, 4)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expect(result).to eq([])
      end
    end

    context 'when positions are adjacent' do
      it 'returns an empty array for horizontally adjacent squares' do
        start_pos = Chess::Position.new(4, 4)
        end_pos = Chess::Position.new(4, 5)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expect(result).to eq([])
      end

      it 'returns an empty array for vertically adjacent squares' do
        start_pos = Chess::Position.new(4, 4)
        end_pos = Chess::Position.new(5, 4)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expect(result).to eq([])
      end

      it 'returns an empty array for diagonally adjacent squares' do
        start_pos = Chess::Position.new(4, 4)
        end_pos = Chess::Position.new(5, 5)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expect(result).to eq([])
      end
    end

    context 'when positions form a horizontal line' do
      it 'returns all squares between positions moving right' do
        start_pos = Chess::Position.new(4, 2)
        end_pos = Chess::Position.new(4, 6)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(4, 3),
          Chess::Position.new(4, 4),
          Chess::Position.new(4, 5)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'returns all squares between horizontal positions moving left' do
        start_pos = Chess::Position.new(4, 6)
        end_pos = Chess::Position.new(4, 2)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(4, 5),
          Chess::Position.new(4, 4),
          Chess::Position.new(4, 3)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'returns all squares for a long horizontal path' do
        start_pos = Chess::Position.new(0, 0)
        end_pos = Chess::Position.new(0, 7)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(0, 1),
          Chess::Position.new(0, 2),
          Chess::Position.new(0, 3),
          Chess::Position.new(0, 4),
          Chess::Position.new(0, 5),
          Chess::Position.new(0, 6)
        ]
        expect(result).to eq(expected_positions)
      end
    end

    context 'when positions form a vertical line' do
      it 'returns all squares between positions moving up' do
        start_pos = Chess::Position.new(2, 4)
        end_pos = Chess::Position.new(6, 4)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(3, 4),
          Chess::Position.new(4, 4),
          Chess::Position.new(5, 4)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'returns all squares between positions from 2nd rank to 6th rank' do
        start_pos = Chess::Position.new(6, 4)
        end_pos = Chess::Position.new(2, 4)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(5, 4),
          Chess::Position.new(4, 4),
          Chess::Position.new(3, 4)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'returns all squares for a long vertical path from 8th rank down to 1st rank' do
        start_pos = Chess::Position.new(0, 3)
        end_pos = Chess::Position.new(7, 3)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(1, 3),
          Chess::Position.new(2, 3),
          Chess::Position.new(3, 3),
          Chess::Position.new(4, 3),
          Chess::Position.new(5, 3),
          Chess::Position.new(6, 3)
        ]
        expect(result).to eq(expected_positions)
      end
    end

    context 'when positions form a diagonal line' do
      it 'returns all squares for diagonal up-right movement' do
        start_pos = Chess::Position.new(2, 2)
        end_pos = Chess::Position.new(6, 6)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(3, 3),
          Chess::Position.new(4, 4),
          Chess::Position.new(5, 5)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'returns all squares for diagonal up-left movement from black perspective' do
        start_pos = Chess::Position.new(2, 6)
        end_pos = Chess::Position.new(6, 2)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(3, 5),
          Chess::Position.new(4, 4),
          Chess::Position.new(5, 3)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'returns all squares for diagonal down-right movement from white perspective' do
        start_pos = Chess::Position.new(6, 2)
        end_pos = Chess::Position.new(2, 6)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(5, 3),
          Chess::Position.new(4, 4),
          Chess::Position.new(3, 5)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'returns all squares for diagonal down-left movement from black perspective' do
        start_pos = Chess::Position.new(6, 6)
        end_pos = Chess::Position.new(2, 2)

        result = calc.calculate_path_between(start: start_pos, destination: end_pos)

        expected_positions = [
          Chess::Position.new(5, 5),
          Chess::Position.new(4, 4),
          Chess::Position.new(3, 3)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'returns all squares for a long diagonal path' do
        start_pos = Chess::Position.new(0, 0)
        end_pos = Chess::Position.new(7, 7)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(1, 1),
          Chess::Position.new(2, 2),
          Chess::Position.new(3, 3),
          Chess::Position.new(4, 4),
          Chess::Position.new(5, 5),
          Chess::Position.new(6, 6)
        ]
        expect(result).to eq(expected_positions)
      end
    end

    context 'when positions do not form a valid line' do
      it 'returns an empty array for knight-like moves' do
        start_pos = Chess::Position.new(2, 2)
        end_pos = Chess::Position.new(4, 3)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expect(result).to eq([])
      end

      it 'returns an empty array for irregular moves' do
        start_pos = Chess::Position.new(1, 1)
        end_pos = Chess::Position.new(4, 6)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expect(result).to eq([])
      end

      it 'returns an empty array for L-shaped moves' do
        start_pos = Chess::Position.new(0, 0)
        end_pos = Chess::Position.new(2, 1)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expect(result).to eq([])
      end
    end

    context 'when dealing with board edge cases' do
      it 'works correctly for paths along the first rank' do
        start_pos = Chess::Position.new(0, 1)
        end_pos = Chess::Position.new(0, 5)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(0, 2),
          Chess::Position.new(0, 3),
          Chess::Position.new(0, 4)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'works correctly for paths along the last rank' do
        start_pos = Chess::Position.new(7, 1)
        end_pos = Chess::Position.new(7, 5)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(7, 2),
          Chess::Position.new(7, 3),
          Chess::Position.new(7, 4)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'works correctly for paths along the first file' do
        start_pos = Chess::Position.new(1, 0)
        end_pos = Chess::Position.new(5, 0)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(2, 0),
          Chess::Position.new(3, 0),
          Chess::Position.new(4, 0)
        ]
        expect(result).to eq(expected_positions)
      end

      it 'works correctly for corner-to-corner diagonal' do
        start_pos = Chess::Position.new(0, 7)
        end_pos = Chess::Position.new(7, 0)
        result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expected_positions = [
          Chess::Position.new(1, 6),
          Chess::Position.new(2, 5),
          Chess::Position.new(3, 4),
          Chess::Position.new(4, 3),
          Chess::Position.new(5, 2),
          Chess::Position.new(6, 1)
        ]
        expect(result).to eq(expected_positions)
      end
    end
  end

  describe '#calculate_path' do
    context 'when called as an instance method' do
      it 'returns the same result as the class method' do
        start_pos = Chess::Position.new(2, 2)
        end_pos = Chess::Position.new(5, 5)
        instance_result = calc.new(start: start_pos, destination: end_pos).calculate_path
        class_result = calc.calculate_path_between(start: start_pos, destination: end_pos)
        expect(instance_result).to eq(class_result)
      end
    end
  end
end
