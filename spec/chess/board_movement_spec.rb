# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Board class

describe Chess::Board do
  subject(:start_board) { described_class.initial_start }

  describe '#possible_moves' do
    context 'when white knight from b1 moves from starting game positions' do
      it 'returns an array with 3 expected destinations' do
        start_pos = Chess::Position.from_algebraic('b1')
        expected_destinations = %w[c3 a3 d2].map { Chess::Position.from_algebraic(it) }
        expect(start_board.possible_moves(start_pos)).to contain_exactly(*expected_destinations)
      end
    end
    context 'when black knight from g8 moves from starting game positions' do
      it 'returns an array with 3 expected destinations' do  
      start_pos = Chess::Position.from_algebraic('g8')
        expected_destinations = %w[f6 h6 e7].map { Chess::Position.from_algebraic(it) }
        expect(start_board.possible_moves(start_pos)).to contain_exactly(*expected_destinations)
      end
    end

    context 'when black rook from a8 moves from starting game position' do
      let(:black_rook) { Chess::Position.from_algebraic('a8') }

      it 'returns an array with 14 moves' do
        expect(start_board.possible_moves(black_rook).length).to eq(14)
      end

      it 'returns the destination move of a6' do
        destination = Chess::Position.from_algebraic('a6')
        expect(start_board.possible_moves(black_rook)).to include(destination)
      end
    end

    context 'when black bishop from c8 moves from starting game positions' do
      let(:black_bishop) { Chess::Position.from_algebraic('c8') }

      it 'returns an array with 7 positions' do
        expect(start_board.possible_moves(black_bishop).length).to eq(7)
      end

      it 'returns the destination move of f5' do
        destination = Chess::Position.from_algebraic('f5')
        expect(start_board.possible_moves(black_bishop)).to include(destination)
      end
    end

    context 'when white queen from d1 moves from starting game positions' do
      let(:white_queen) { Chess::Position.from_algebraic('d1') }

      it 'returns an array with 21 positions' do
        expect(start_board.possible_moves(white_queen).length).to eq(21)
      end

      it 'returns the destination move of f3' do
        destination = Chess::Position.from_algebraic('f3')
        expect(start_board.possible_moves(white_queen)).to include(destination)
      end
    end

    context 'when the black king from e8 moves from starting game positions' do
      let(:black_king) { Chess::Position.from_algebraic('e8') }

      it 'returns an array with 5 positions' do
        expect(start_board.possible_moves(black_king).length).to eq(5)
      end

      it 'returns the destination move of e7' do
        destination = Chess::Position.from_algebraic('e7')
        expect(start_board.possible_moves(black_king)).to include(destination)
      end
    end

    context 'when the white pawn at c2 moves' do
      let(:white_pawn) { Chess::Position.from_algebraic('c2') }

      it 'returns an array with 3 positions' do
        expect(start_board.possible_moves(white_pawn).length).to eq(4)
      end

      it 'returns the destination move of c3' do
        destination = Chess::Position.from_algebraic('c3')
        expect(start_board.possible_moves(white_pawn)).to include(destination)
      end

      it 'returns the capture destination move of d3' do
        destination = Chess::Position.from_algebraic('d3')
        expect(start_board.possible_moves(white_pawn)).to include(destination)
      end
    end

    context 'when the black pawn at g7 moves' do
      let(:black_pawn) { Chess::Position.from_algebraic('g7') }

      it 'returns an array with 3 positions' do
        expect(start_board.possible_moves(black_pawn).length).to eq(4)
      end

      it 'returns the destination move of g6' do
        destination = Chess::Position.from_algebraic('g6')
        expect(start_board.possible_moves(black_pawn)).to include(destination)
      end

      it 'returns the capture destination move of h6' do
        destination = Chess::Position.from_algebraic('h6')
        expect(start_board.possible_moves(black_pawn)).to include(destination)
      end

      it 'returns the first move double-square to destination g5' do
        destination = Chess::Position.from_algebraic('g5')
        expect(start_board.possible_moves(black_pawn)).to include(destination)
      end
    end

    context 'when there is no piece at b5' do
      let(:empty_position) { Chess::Position.from_algebraic('b5') }

      it 'returns no piece symbol' do
        expect(start_board.possible_moves(empty_position)).to eq([])
      end
    end

    context 'when a white knight is at d5' do
      let(:empty_board) { described_class.new }
      let(:knight_position) { Chess::Position.from_algebraic('d5') }

      it 'returns 8 possible positions' do
        empty_board.place_piece(knight_position, 'k')
        result = empty_board.possible_moves(knight_position)
        expect(result.length).to eq(8)
      end
    end
  end
end
