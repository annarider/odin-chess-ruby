# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for Castling class

describe Chess::CastlingValidator do
  subject(:validator) { described_class }

  # Helper methods to create real Position and Move objects
  def position(square)
    Chess::Position.from_algebraic(square)
  end

  def create_castling_move(from_square, to_square, piece, rook_square, fen)
    Chess::Move.new(
      from_position: position(from_square),
      to_position: position(to_square),
      piece: piece,
      castling: position(rook_square),
      fen: fen
    )
  end

  def create_regular_move(from_square, to_square, piece, fen)
    Chess::Move.new(
      from_position: position(from_square),
      to_position: position(to_square),
      piece: piece,
      fen: fen
    )
  end

  # Use real board setup for testing
  def setup_castling_board
    # Create a board with kings and rooks in castling positions
    # and clear the path between them
    Chess::Board.start_positions(add_pieces: true).tap do |board|
      # Remove pieces between king and rook for castling
      board.remove_piece(position('f1'))
      board.remove_piece(position('g1'))
      board.remove_piece(position('b1'))
      board.remove_piece(position('c1'))
      board.remove_piece(position('d1'))
      # Similar for black pieces
      board.remove_piece(position('f8'))
      board.remove_piece(position('g8'))
      board.remove_piece(position('b8'))
      board.remove_piece(position('c8'))
      board.remove_piece(position('d8'))
    end
  end

  describe '.castling_legal?' do
    let(:board) { setup_castling_board }
    let(:move_history) { Chess::MoveHistory.new }

    # Test the happy path - when all castling conditions are met
    context 'when all castling conditions are met' do
      let(:starting_fen) { 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R b KQkq - 0 1' }

      it 'returns true for valid white kingside castling' do
        move = create_castling_move('e1', 'g1', 'K', 'h1', starting_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be true
      end

      it 'returns true for valid white queenside castling' do
        move = create_castling_move('e1', 'c1', 'K', 'a1', starting_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be true
      end

      it 'returns true for valid black kingside castling' do
        move = create_castling_move('e8', 'g8', 'k', 'h8', starting_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be true
      end

      it 'returns true for valid black queenside castling' do
        move = create_castling_move('e8', 'c8', 'k', 'a8', starting_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be true
      end
    end

    context 'when the king has previously moved' do
      before do
        # Simulate king moving by adding moves to history
        # King moves from e8 to e7
        fen_after_king_move = 'r6r/ppppkppp/8/8/8/8/PPPPPPPP/R3K2R w KQq - 1 1'
        king_move = create_regular_move('e8', 'e7', 'K', fen_after_king_move)
        move_history.add_move(king_move)
        # FEN after king moves back to e8 (but castling rights lost)
        fen_king_back = 'r3k2r/pppp1ppp/8/8/8/8/PPPPPPPP/R3K2R b KQq - 2 1'
        king_move_back = create_regular_move('e7', 'e8', 'K', fen_king_back)
        move_history.add_move(king_move_back)
      end

      it 'returns false' do
        # Current FEN shows king back on e8 but without black castling rights kq
        current_fen = 'r3k2r/pppp1ppp/8/8/8/8/PPPPPPPP/R3K2R b KQ - 2 1'
        move = create_castling_move('e8', 'g8', 'K', 'h8', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be false
      end
    end

    context 'when the rook has previously moved' do
      before do
        # FEN after rook moves (kingside castling right lost for black, based on cleared board)
        fen_after_rook_move = 'r3k3/pppppprp/8/8/8/8/PPPPPPPP/R3K2R w KQq - 1 1'
        rook_move_out = create_regular_move('h8', 'h7', 'r', fen_after_rook_move)
        move_history.add_move(rook_move_out)
        # FEN after rook moves back (kingside castling still lost for black)
        fen_rook_back = 'r3k2r/pppppp1p/8/8/8/8/PPPPPPPP/R3K2R b KQq - 2 1'
        rook_move_back = create_regular_move('h7', 'h8', 'r', fen_rook_back)
        move_history.add_move(rook_move_back)
      end

      it 'returns false' do
        current_fen = 'r3k2r/pppppp1p/8/8/8/8/PPPPPPPP/R3K2R b KQq - 2 1'
        move = create_castling_move('e8', 'g8', 'K', 'h8', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be false
      end
    end

    context 'when the king is currently in check' do
      before do
        # Place a white queen that puts black king in check
        board.place_piece(position('e6'), 'Q')
      end

      it 'returns false' do
        # King in check - cannot castle (cleared board + white queen on e6)
        current_fen = 'r3k2r/pppppppp/4Q3/8/8/8/PPPPPPPP/R3K2R b KQkq - 1 1'
        move = create_castling_move('e8', 'g8', 'K', 'h8', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be false
      end
    end

    context 'when the castling path is under attack' do
      before do
        # Place a white rook that attacks f8 (king would pass through check)
        board.place_piece(position('f1'), 'R')
      end

      it 'returns false' do
        # f8 square under attack - king cannot pass through (cleared board + rook on f1)
        current_fen = 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3KR1R b KQkq - 0 1'
        move = create_castling_move('e8', 'g8', 'K', 'h8', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be false
      end
    end

    context 'when castling would put the king in check' do
      before do
        # Place a white rook that attacks g8 (where king would end up)
        board.place_piece(position('g8'), 'r')
      end

      it 'returns true' do
        # g1 square under attack - white king cannot end there (black rook on g8)
        current_fen = 'r3k1r1/pppppppp/8/8/8/8/PPPPPPPP/R3K2R b KQkq - 0 1'
        move = create_castling_move('e1', 'g1', 'K', 'h1', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be true
      end
    end

    context 'when queenside castling path square is under attack' do
      before do
        # Place a black bishop that attacks d1:
        # king passes through this square during queenside castling
        board.place_piece(position('a4'), 'b')
      end

      it 'returns false when d1 square is attacked' do
        # d1 square under attack - king cannot pass through check during queenside castling
        current_fen = 'r3k2r/pppppppp/8/8/b7/8/PP1PPPPP/R3K2R w KQkq - 0 1'
        move = create_castling_move('e1', 'c1', 'K', 'a1', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be false
      end
    end

    context 'when the specific castling rook has moved' do
      before do
        # Set up move history where h1 rook has moved (but returned)
        fen_after_rook_move = 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K3 w KQq - 1 1'
        rook_move_out = create_regular_move('h1', 'h2', 'R', fen_after_rook_move)
        move_history.add_move(rook_move_out)

        fen_rook_back = 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQq - 2 1'
        rook_move_back = create_regular_move('h2', 'h1', 'R', fen_rook_back)
        move_history.add_move(rook_move_back)
      end

      it 'returns false when the castling rook has previously moved' do
        # h1 rook has moved and returned - castling rights lost for kingside
        current_fen = 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQq - 2 1'
        move = create_castling_move('e1', 'g1', 'K', 'h1', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be false
      end
    end

    context 'when the other rook has moved but not the castling rook' do
      before do
        # Set up move history where a1 rook has moved (but h1 rook hasn't)
        fen_after_rook_move = 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/4K2R w Kk - 1 1'
        rook_move = create_regular_move('a1', 'a2', 'R', fen_after_rook_move)
        move_history.add_move(rook_move)
      end

      it 'returns true when only the other rook has moved' do
        # a1 rook moved but h1 rook hasn't - kingside castling still allowed
        current_fen = 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/4K2R w Kk - 1 1'
        move = create_castling_move('e1', 'g1', 'K', 'h1', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be true
      end
    end

    context 'when testing white piece castling' do
      it 'correctly identifies white player from uppercase piece' do
        # White king castling kingside - should work with clear board
        current_fen = 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQkq - 0 1'
        move = create_castling_move('e1', 'g1', 'K', 'h1', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be true
      end
    end

    context 'when testing black piece castling' do
      it 'correctly identifies black player from lowercase piece' do
        # Black king castling kingside - should work with clear board
        current_fen = 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R b KQkq - 0 1'
        move = create_castling_move('e8', 'g8', 'k', 'h8', current_fen)
        result = validator.castling_legal?(board, move, move_history)
        expect(result).to be true
      end
    end
  end
end
