# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for Pawn Move Validator

describe Chess::PawnMoveValidator do
  subject(:validator) { described_class }
  describe '.valid_move?' do
    # Helper methods to create real objects (following EnPassantValidator pattern)
    def position(square)
      Chess::Position.from_algebraic(square)
    end

    def create_move(from_square:, to_square:, piece_symbol:)
      Chess::Move.new(
        from_position: position(from_square),
        to_position: position(to_square),
        piece: piece_symbol
      )
    end

    def setup_board_with_pieces(white_pieces: {}, black_pieces: {})
      board = Chess::Board.new
      white_pieces.each { |square, piece| board.place_piece(position(square), piece) }
      black_pieces.each { |square, piece| board.place_piece(position(square), piece) }
      board
    end

    let(:empty_board) { Chess::Board.new }

    context 'when pawn makes forward moves to empty squares' do
      it 'allows white pawn to move one square forward from starting position' do
        board = setup_board_with_pieces(white_pieces: { 'e2' => 'P' })
        move = create_move(from_square: 'e2', to_square: 'e3', piece_symbol: 'P')

        result = validator.valid_move?(board, move)

        expect(result).to be true
      end

      it 'allows black pawn to move one square forward from starting position' do
        board = setup_board_with_pieces(black_pieces: { 'e7' => 'p' })
        move = create_move(from_square: 'e7', to_square: 'e6', piece_symbol: 'p')

        result = validator.valid_move?(board, move)

        expect(result).to be true
      end

      it 'allows white pawn to move two squares from starting position when unmoved' do
        board = setup_board_with_pieces(white_pieces: { 'e2' => 'P' })
        move = create_move(from_square: 'e2', to_square: 'e4', piece_symbol: 'P')

        result = validator.valid_move?(board, move)

        expect(result).to be true
      end

      it 'allows black pawn to move two squares from starting position when unmoved' do
        board = setup_board_with_pieces(black_pieces: { 'e7' => 'p' })
        move = create_move(from_square: 'e7', to_square: 'e5', piece_symbol: 'p')

        result = validator.valid_move?(board, move)

        expect(result).to be true
      end

      it 'rejects white pawn two-square move when pawn has already moved' do
        board = setup_board_with_pieces(white_pieces: { 'e3' => 'P' })
        move = create_move(from_square: 'e3', to_square: 'e5', piece_symbol: 'P')

        expect(validator.valid_move?(board, move)).to be false
      end

      it 'rejects black pawn two-square move when pawn has already moved' do
        board = setup_board_with_pieces(black_pieces: { 'e6' => 'p' })
        move = create_move(from_square: 'e6', to_square: 'e4', piece_symbol: 'p')

        expect(validator.valid_move?(board, move)).to be false
      end
    end

    context 'when pawn makes diagonal capture moves' do
      it 'allows white pawn to capture black piece diagonally' do
        board = setup_board_with_pieces(
          white_pieces: { 'e5' => 'P' },
          black_pieces: { 'd6' => 'p' }
        )
        move = create_move(from_square: 'e5', to_square: 'd6', piece_symbol: 'P')

        expect(validator.valid_move?(board, move)).to be true
      end

      it 'allows black pawn to capture white piece diagonally' do
        board = setup_board_with_pieces(
          white_pieces: { 'd3' => 'P' },
          black_pieces: { 'e4' => 'p' }
        )
        move = create_move(from_square: 'e4', to_square: 'd3', piece_symbol: 'p')

        expect(validator.valid_move?(board, move)).to be true
      end

      it 'rejects white pawn trying to capture own piece' do
        board = setup_board_with_pieces(
          white_pieces: { 'e5' => 'P', 'd6' => 'N' }
        )
        move = create_move(from_square: 'e5', to_square: 'd6', piece_symbol: 'P')

        expect(validator.valid_move?(board, move)).to be false
      end

      it 'rejects black pawn trying to capture own piece' do
        board = setup_board_with_pieces(
          black_pieces: { 'e4' => 'p', 'd3' => 'n' }
        )
        move = create_move(from_square: 'e4', to_square: 'd3', piece_symbol: 'p')

        expect(validator.valid_move?(board, move)).to be false
      end

      it 'rejects diagonal move to empty square' do
        board = setup_board_with_pieces(white_pieces: { 'e5' => 'P' })
        move = create_move(from_square: 'e5', to_square: 'd6', piece_symbol: 'P')

        result = validator.valid_move?(board, move)

        expect(result).to be false
      end
    end

    context 'when pawn wants to advance two squares to capture' do
      it 'rejects two square advance' do
        board = Chess::Board.from_fen('rnb1kbnr/pppp1ppp/8/4p3/7q/5P2/PPPPP1PP/RNBQKBNR w KQkq - 1 3')
        move = create_move(from_square: 'h2', to_square: 'h4', piece_symbol: 'P')
        result = validator.valid_move?(board, move)
        expect(result).to be false
      end
    end

    context 'when handling edge cases' do
      it 'handles move from edge of board' do
        board = setup_board_with_pieces(white_pieces: { 'a5' => 'P' })
        move = create_move(from_square: 'a5', to_square: 'a6', piece_symbol: 'P')

        expect(validator.valid_move?(board, move)).to be true
      end

      it 'allows capture on edge of board' do
        board = setup_board_with_pieces(
          white_pieces: { 'a5' => 'P' },
          black_pieces: { 'b6' => 'p' }
        )
        move = create_move(from_square: 'a5', to_square: 'b6', piece_symbol: 'P')

        expect(validator.valid_move?(board, move)).to be true
      end
    end

    context 'when testing realistic game scenarios' do
      it 'validates standard opening pawn moves' do
        board = Chess::Board.start_positions(add_pieces: true)

        white_move = create_move(from_square: 'e2', to_square: 'e4', piece_symbol: 'P')
        expect(validator.valid_move?(board, white_move)).to be true

        black_move = create_move(from_square: 'd7', to_square: 'd5', piece_symbol: 'p')
        expect(validator.valid_move?(board, black_move)).to be true
      end
    end
  end
end
