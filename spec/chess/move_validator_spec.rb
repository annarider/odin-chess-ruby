# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for module Chess::Move Validator via Board class

describe Chess::Board do
  subject(:board) { described_class.new }

  describe '#is_move_legal?' do
    context 'when a white knight in the middle of an empty board moves' do
      it 'returns true' do
        knight_start = Chess::Position.from_algebraic('d5')
        knight_destination = Chess::Position.from_algebraic('c3')
        move = Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N')
        board.place_piece(knight_start, 'N')
        result = board.valid_move?(move)
        expect(result).to be true
      end
    end

    context 'when a black rook moves diagonally' do
      it 'returns false' do
        rook_start = Chess::Position.from_algebraic('a8')
        rook_destination = Chess::Position.from_algebraic('f7')
        move = Chess::Move.new(from_position: rook_start, to_position: rook_destination, piece: 'N')
        board.place_piece(rook_start, 'N')
        expect(board.valid_move?(move)).to be false
      end
    end

    context 'when a black knight captures' do
      let(:knight_start) { Chess::Position.from_algebraic('f6') }
      let(:knight_destination) { Chess::Position.from_algebraic('e4') }
      let(:move) { Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'n') }

      before do
        board.place_piece(knight_start, 'n')
      end

      it 'returns true for a white pawn' do
        board.place_piece(knight_destination, 'P')
        expect(board.valid_move?(move)).to be true
      end

      it 'returns false for a black pawn' do
        board.place_piece(knight_destination, 'p')
        expect(board.valid_move?(move)).to be false
      end
    end

    context 'when starting a new game' do
      subject(:start_board) { described_class.initial_start(add_pieces: true) }

      it 'returns false when white bishop path is blocked' do
        bishop_start = Chess::Position.from_algebraic('c1')
        bishop_destination = Chess::Position.from_algebraic('e3')
        move = Chess::Move.new(from_position: bishop_start, to_position: bishop_destination, piece: 'B')
        expect(start_board.valid_move?(move)).to be false
      end

      it 'returns true for white knight which can leap over pieces' do
        knight_start = Chess::Position.from_algebraic('b1')
        knight_destination = Chess::Position.from_algebraic('c3')
        move = Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N')
        expect(start_board.valid_move?(move)).to be true
      end
    end
  end
end
