# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for module Move Validator

describe Chess::Board do
  let(:empty_board) { described_class.initial_start(add_pieces: false) }
  let(:start_board) { described_class.initial_start }

  describe '#valid_move?' do
    context 'when a knight in the middle of an empty board moves' do
      let(:knight_start) { Chess::Position.from_algebraic('d5') }
      let(:knight_destination) { Chess::Position.from_algebraic('c3') }
      let(:knight_move) do
        Chess::Move.new(
          from_position: knight_start,
          to_position: knight_destination,
          piece: 'N'
        )
      end

      it 'returns true' do
        empty_board.place_piece(knight_start, 'N')
        expect(empty_board.valid_move?(knight_move)).to be true
      end
    end

    context 'when a black rook moves diagonally' do
      let(:rook_start) { Chess::Position.from_algebraic('a8') }
      let(:rook_end) { Chess::Position.from_algebraic('b7') }
      let(:rook_move) do
        Chess::Move.new(
          from_position: rook_start,
          to_position: rook_end,
          piece: 'N'
        )
      end

      it 'returns false' do
        expect(start_board.valid_move?(rook_move)).to be false
      end
    end
  end
end
