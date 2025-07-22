# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Board class

describe Chess::Board do
  subject(:start_board) { described_class.initial_start }

  describe '#possible_moves' do
    context 'when white knight from b1 moves from starting game positions' do
      let(:start_pos) { Chess::Position.from_algebraic('b1') }
      let(:destination) { Chess::Position.from_algebraic('c3') }

      it 'returns an array with 3 moves' do
        expect(start_board.possible_moves(start_pos).length).to eq(3)
      end

      it 'returns the destination move of c3' do
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end

      it 'returns the alternative destination of a3' do
        alt_destination = Chess::Position.from_algebraic('a3')
        expect(start_board.possible_moves(start_pos)).to include(alt_destination)
      end
    end

    context 'when black knight from g8 moves from starting game positions' do
      let(:start_pos) { Chess::Position.from_algebraic('g8') }

      it 'returns an array with 3 moves' do
        expect(start_board.possible_moves(start_pos).length).to eq(3)
      end

      it 'returns the destination move of f6' do
        destination = Chess::Position.from_algebraic('f6')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end
    end

    context 'when black rook from a8 moves from starting game position' do
      let(:start_pos) { Chess::Position.from_algebraic('a8') }

      it 'returns an array with 14 moves' do
        expect(start_board.possible_moves(start_pos).length).to eq(14)
      end

      it 'returns the destination move of a6' do
        destination = Chess::Position.from_algebraic('a6')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end
    end

    context 'when black bishop from c8 moves from starting game positions' do
      let(:start_pos) { Chess::Position.from_algebraic('c8') }

      it 'returns an array with 7 positions' do
        expect(start_board.possible_moves(start_pos).length).to eq(7)
      end

      it 'returns the destination move of f5' do
        destination = Chess::Position.from_algebraic('f5')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end
    end

    context 'when white queen from d1 moves from starting game positions' do
      let(:start_pos) { Chess::Position.from_algebraic('d1') }

      it 'returns an array with 21 positions' do
        expect(start_board.possible_moves(start_pos).length).to eq(21)
      end

      it 'returns the destination move of f3' do
        destination = Chess::Position.from_algebraic('f3')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end
    end

    context 'when the black king from e8 moves from starting game positions' do
      let(:start_pos) { Chess::Position.from_algebraic('e8') }

      it 'returns an array with 5 positions' do
        expect(start_board.possible_moves(start_pos).length).to eq(5)
      end

      it 'returns the destination move of e7' do
        destination = Chess::Position.from_algebraic('e7')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end
    end

    context 'when the white pawn at c2 moves' do
      let(:start_pos) { Chess::Position.from_algebraic('c2') }

      it 'returns an array with 3 positions' do
        expect(start_board.possible_moves(start_pos).length).to eq(4)
      end

      it 'returns the destination move of c3' do
        destination = Chess::Position.from_algebraic('c3')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end

      it 'returns the capture destination move of d3' do
        destination = Chess::Position.from_algebraic('d3')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end
    end

    context 'when the black pawn at g7 moves' do
      let(:start_pos) { Chess::Position.from_algebraic('g7') }

      it 'returns an array with 3 positions' do
        expect(start_board.possible_moves(start_pos).length).to eq(4)
      end

      it 'returns the destination move of g6' do
        destination = Chess::Position.from_algebraic('g6')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end

      it 'returns the capture destination move of h6' do
        destination = Chess::Position.from_algebraic('h6')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end

      it 'returns the first move double-square to destination g5' do
        destination = Chess::Position.from_algebraic('g5')
        expect(start_board.possible_moves(start_pos)).to include(destination)
      end
    end

    context 'when there is no piece at b5' do
      let(:start_pos) { Chess::Position.from_algebraic('b5') }

      it 'returns no piece symbol' do
        expect(start_board.possible_moves(start_pos)).to eq(:no_piece)
      end
    end
  end
end
