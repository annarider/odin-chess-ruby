# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Chess Position class

describe Chess::Position do
  let(:top_left_position) { described_class.from_coordinates(0, 0) }
  let(:top_right_position) { described_class.from_coordinates(0, 7) }
  let(:bottom_left_position) { described_class.from_coordinates(7, 0) }
  let(:bottom_right_position) { described_class.from_coordinates(7, 7) }

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

  describe '#rank' do
    it 'returns 8 for a8, top left square, when the row is 0 index' do
      expect(top_left_position.rank).to eq('8')
    end

    it 'returns 1 for h1, bottom right square, when the row is 7 index' do
      expect(bottom_right_position.rank).to eq('1')
    end

    it 'returns nil for an out-of-bounds position' do
      negative_direction = described_class.from_directional_vector(Chess::Directions::PAWN_WHITE[0])
      expect(negative_direction.rank).to be_nil
    end
  end

  describe '#file' do
    it 'returns a for a8, top left square, when the column is 0 index' do
      expect(top_left_position.file).to eq('a')
    end

    it 'returns h for h8, top right square, when the column is 7 index' do
      expect(top_right_position.file).to eq('h')
    end

    it 'returns nil for an out-of-bounds position' do
      described_class.from_directional_vector(Chess::Directions::PAWN_WHITE[0])
    end
  end

  describe 'square' do
    it 'returns a1, bottom left square, when coordinates are [0, 7]' do
      expect(bottom_left_position.square).to eq('a1')
    end

    it 'returns h1, bottom right square, when coordinates are [7, 7]' do
      expect(bottom_right_position.square).to eq('h1')
    end

    it 'returns nil for an out-of-bounds position' do
      negative_direction = described_class.from_directional_vector(Chess::Directions::KNIGHT[0])
      expect(negative_direction.square).to be_nil
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

    it 'returns nil if out-of-bounds position' do
      negative_direction = described_class.from_directional_vector(Chess::Directions::ROOK[0])
      expect(negative_direction.coordinates).to be_nil
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
        direction = described_class.from_directional_vector(Chess::Directions::PAWN_WHITE[0])
        destination = start_position.transform_coordinates(direction)
        expect(destination).to eq(described_class.from_coordinates(5, 0))
      end

      it 'returns the position 2 squares up' do
        start_position = described_class.from_coordinates(6, 1)
        direction = described_class.from_directional_vector([-2, 0])
        destination = start_position.transform_coordinates(direction)
        expect(destination).to eq(described_class.from_coordinates(4, 1))
      end

      it 'returns nil when new position is out of bounds' do
        start_position = described_class.from_algebraic('h6')
        direction = described_class.from_directional_vector(Chess::Directions::PAWN_BLACK[2])
        destination = start_position.transform_coordinates(direction)
        expect(destination).to be_nil
      end
    end
  end

  describe '#+' do
    context 'when using algebraic notation as black rook' do
      it 'returns the position 1 forward square advance to a7' do
        start_position = described_class.from_algebraic('a7')
        direction = described_class.from_directional_vector(Chess::Directions::PAWN_BLACK[0])
        destination = start_position + direction
        expect(destination).to eq(described_class.from_algebraic('a6'))
      end

      it 'returns the position 1 left square advance to b8' do
        start_position = described_class.from_algebraic('a7')
        direction = described_class.from_directional_vector(Chess::Directions::PAWN_BLACK[2])
        destination = start_position + direction
        expect(destination).to eq(described_class.from_algebraic('b6'))
      end
    end
  end

  describe '#-' do
    context 'when pawn moves 1 rank' do
      from_position = described_class.from_algebraic('a2')
      to_position = described_class.from_algebraic('a3')

      it 'returns a Position with 1 rank difference' do
        expect((from_position - to_position).row.abs).to eq(1)
      end
    end

    context 'when pawn moves 2 ranks' do
      from_position = described_class.from_algebraic('b2')
      to_position = described_class.from_algebraic('b4')

      it 'returns a Position with 2 rank difference' do
        expect((from_position - to_position).row.abs).to eq(2)
      end
    end
  end

  describe '#two_rank_move?' do
    context 'when white pawn advances two squares forward' do
      start_pos = described_class.from_algebraic('c2')
      destination = described_class.from_algebraic('c4')
      it 'returns true' do
        expect(start_pos.two_rank_move?(destination)).to be true
      end
    end
  end

  describe '#two_rank_move?' do
    context 'when black pawn advances two squares forward' do
      start_pos = described_class.from_algebraic('e7')
      destination = described_class.from_algebraic('e5')
      it 'returns true' do
        expect(start_pos.two_rank_move?(destination)).to be true
      end
    end
  end

  describe '#two_rank_move?' do
    context 'when queen advances one squares forward' do
      start_pos = described_class.from_algebraic('d4')
      destination = described_class.from_algebraic('d5')
      it 'returns false' do
        expect(start_pos.two_rank_move?(destination)).to be false
      end
    end
  end

  describe '#diagonal_move?'
    context 'when black pawn captures' do
      start_pos = described_class.from_algebraic('d7')
      destination = described_class.from_algebraic('e6')
      it 'returns true' do
        expect(start_pos.diagonal_move?(destination)).to be true
      end
    end
    context 'when white pawn captures' do
      start_pos = described_class.from_algebraic('e2')
      destination = described_class.from_algebraic('f3')
      it 'returns true' do
        expect(start_pos.diagonal_move?(destination)).to be true
      end
    end
    context 'when rook moves' do
      start_pos = described_class.from_algebraic('a1')
      destination = described_class.from_algebraic('a2')
      it 'returns true' do
        expect(start_pos.diagonal_move?(destination)).to be false
      end
    end
end
