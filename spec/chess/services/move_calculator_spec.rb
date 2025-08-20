# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Chess Board class

describe Chess::MoveCalculator do
  subject(:calculator) { described_class }

  let(:start_board) { Chess::Board.start_positions(add_pieces: true) }

  describe '#generate_possible_moves' do
    context 'when white knight from b1 moves from starting game positions' do
      it 'returns an array with 3 expected destinations' do
        start_pos = Chess::Position.from_algebraic('b1')
        expected_destinations = %w[c3 a3 d2].map { Chess::Position.from_algebraic(it) }
        expect(calculator.generate_possible_moves(start_pos, 'N')).to match_array(expected_destinations)
      end
    end

    context 'when black knight from g8 moves from starting game positions' do
      it 'returns an array with 3 expected destinations' do
        start_pos = Chess::Position.from_algebraic('g8')
        expected_destinations = %w[f6 h6 e7].map { Chess::Position.from_algebraic(it) }
        expect(calculator.generate_possible_moves(start_pos, 'n')).to match_array(expected_destinations)
      end
    end

    context 'when black rook from a8 moves from starting game position' do
      let(:black_rook) { Chess::Position.from_algebraic('a8') }

      it 'returns an array with 14 moves' do
        expect(calculator.generate_possible_moves(black_rook, 'r').length).to eq(14)
      end

      it 'returns the destination move of a6' do
        destination = Chess::Position.from_algebraic('a6')
        expect(calculator.generate_possible_moves(black_rook, 'r')).to include(destination)
      end
    end

    context 'when black bishop from c8 moves from starting game positions' do
      let(:black_bishop) { Chess::Position.from_algebraic('c8') }

      it 'returns an array with 7 positions' do
        expect(calculator.generate_possible_moves(black_bishop, 'b').length).to eq(7)
      end

      it 'returns the destination move of f5' do
        destination = Chess::Position.from_algebraic('f5')
        expect(calculator.generate_possible_moves(black_bishop, 'b')).to include(destination)
      end
    end

    context 'when white queen from d1 moves from starting game positions' do
      let(:white_queen) { Chess::Position.from_algebraic('d1') }

      it 'returns an array with 21 positions' do
        expect(calculator.generate_possible_moves(white_queen, 'Q').length).to eq(21)
      end

      it 'returns the destination move of f3' do
        destination = Chess::Position.from_algebraic('f3')
        expect(calculator.generate_possible_moves(white_queen, 'Q')).to include(destination)
      end
    end

    context 'when the black king from e8 moves from starting game positions' do
      let(:black_king) { Chess::Position.from_algebraic('e8') }

      it 'returns an array with 5 positions' do
        expect(calculator.generate_possible_moves(black_king, 'k').length).to eq(5)
      end

      it 'returns the destination move of e7' do
        destination = Chess::Position.from_algebraic('e7')
        expect(calculator.generate_possible_moves(black_king, 'k')).to include(destination)
      end
    end

    context 'when the white pawn at c2 moves' do
      it 'returns an array with 4 positions' do
        start_pos = Chess::Position.from_algebraic('c2')
        expected_destinations = %w[c3 c4 b3 d3].map { Chess::Position.from_algebraic(it) }
        expect(calculator.generate_possible_moves(start_pos, 'P')).to match_array(expected_destinations)
      end
    end

    context 'when the black pawn at g7 moves' do
      it 'returns an array with 4 positions' do
        start_pos = Chess::Position.from_algebraic('g7')
        expected_destinations = %w[f6 g6 h6 g5].map { Chess::Position.from_algebraic(it) }
        expect(calculator.generate_possible_moves(start_pos, 'p')).to match_array(expected_destinations)
      end
    end

    context 'when there is no piece at b5' do
      let(:empty_position) { Chess::Position.from_algebraic('b5') }

      it 'returns no piece symbol' do
        expect(calculator.generate_possible_moves(empty_position, nil)).to eq([])
      end
    end

    context 'when a white knight is at d5' do
      it 'returns 8 expected destination positions' do
        start_pos = Chess::Position.from_algebraic('d5')
        expected_destinations = %w[e7 f6 f4 e3 c3 b4 b6 c7].map { Chess::Position.from_algebraic(it) }
        expect(calculator.generate_possible_moves(start_pos, 'N')).to match_array(expected_destinations)
      end
    end
  end
end
