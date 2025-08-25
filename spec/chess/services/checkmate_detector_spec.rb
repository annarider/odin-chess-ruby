# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::CheckmateDetector do
  describe '.checkmate?' do
    context 'when king is not in check' do
      it 'returns false for starting position' do
        board = Chess::Board.start_positions(add_pieces: true)
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER)
        
        expect(result).to be false
      end

      it 'returns false when king has escaped check' do
        # Position where white king was in check but moved to safety
        board = Chess::Board.from_fen('rnbqkbnr/pppp1ppp/8/4p3/6P1/8/PPPPP1qP/RNBQKBNR w KQkq - 2 3')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER)
        
        expect(result).to be false
      end
    end

    context 'when king is in check but can escape' do
      it 'returns false when king has legal moves to escape check' do
        # Scholar's mate attempt - black queen attacks f2, but white king can move
        board = Chess::Board.from_fen('rnb1kbnr/pppp1ppp/8/4p3/2B1P3/8/PPPP1qPP/RNBQK1NR w KQkq - 2 3')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER)
        
        expect(result).to be false
      end

      it 'returns false when attacking piece can be captured' do
        # White queen attacks black king but can be captured by black pieces
        board = Chess::Board.from_fen('rnbqkbnr/ppp2ppp/8/3Qp3/4P3/8/PPPP1PPP/RNB1KBNR b KQkq - 1 3')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::BLACK_PLAYER)
        
        expect(result).to be false
      end

      it 'returns false when check can be blocked' do
        # Rook gives check but can be blocked
        board = Chess::Board.from_fen('r3k3/8/8/8/8/8/4R3/4K3 b - - 0 1')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::BLACK_PLAYER)
        
        expect(result).to be false
      end
    end

    context 'when position is checkmate' do
      it 'returns true for fools mate' do
        # Fastest checkmate in chess
        board = Chess::Board.from_fen('rnb1kbnr/pppp1ppp/8/4p3/6Pq/8/PPPPP2P/RNBQKBNR w KQkq - 1 3')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER)
        
        expect(result).to be true
      end

      it 'returns true for scholars mate' do
        # Classic four-move checkmate
        board = Chess::Board.from_fen('r1bqkb1r/pppp1Qpp/2n2n2/4p3/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 4')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::BLACK_PLAYER)
        
        expect(result).to be true
      end

      it 'returns true for back rank mate' do
        # King trapped on back rank by own pawns, attacked by rook
        board = Chess::Board.from_fen('6rk/6pp/8/8/8/8/5PPP/5RK1 w - - 0 1')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER)
        
        expect(result).to be true
      end

      it 'returns true for queen and king endgame mate' do
        # Queen supported by king delivers mate
        board = Chess::Board.from_fen('8/8/8/8/8/6k1/8/5QK1 b - - 0 1')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::BLACK_PLAYER)
        
        expect(result).to be true
      end

      it 'returns true for smothered mate' do
        # Knight on f7 delivers mate while king is trapped by its own pieces
        board = Chess::Board.from_fen('6rk/5Npp/8/8/8/8/8/6K1 w - - 0 1')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::BLACK_PLAYER)
        
        expect(result).to be true
      end
    end

    context 'when position is stalemate' do
      it 'returns false when king is not in check but has no legal moves' do
        # Classic stalemate position
        board = Chess::Board.from_fen('8/8/8/8/8/6k1/5q2/5K2 w - - 0 1')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER)
        
        expect(result).to be false
      end

      it 'returns false for king and pawn vs king stalemate' do
        # Stalemate in king and pawn endgame
        board = Chess::Board.from_fen('8/8/8/8/8/1k6/1P6/1K6 b - - 0 1')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::BLACK_PLAYER)
        
        expect(result).to be false
      end
    end

    context 'when testing with explicit king position' do
      it 'returns true when king at specified position is in checkmate' do
        board = Chess::Board.from_fen('rnb1kbnr/pppp1ppp/8/4p3/6Pq/8/PPPPP2P/RNBQKBNR w KQkq - 1 3')
        king_position = Chess::Position.from_algebraic('e1')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER, king_position)
        
        expect(result).to be true
      end

      it 'returns false when king at specified position is not in checkmate' do
        board = Chess::Board.start_positions(add_pieces: true)
        king_position = Chess::Position.from_algebraic('e1')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER, king_position)
        
        expect(result).to be false
      end
    end

    context 'when testing edge cases' do
      it 'returns false when king cannot be found on board' do
        board = Chess::Board.new
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER)
        
        expect(result).to be false
      end

      it 'returns false when only kings are on the board' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::WHITE_PLAYER)
        
        expect(result).to be false
      end

      it 'handles complex middlegame positions correctly' do
        # Complex position that is not checkmate
        board = Chess::Board.from_fen('r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R b KQkq - 0 4')
        
        result = described_class.checkmate?(board, Chess::ChessNotation::BLACK_PLAYER)
        
        expect(result).to be false
      end
    end
  end
end