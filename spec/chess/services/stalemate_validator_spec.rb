# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::StalemateValidator do
  subject(:validator) { described_class }

  describe '.stalemate?' do
    context 'when king is in check' do
      it 'returns false for check position' do
        board = Chess::Board.from_fen('8/8/8/8/8/6k1/6Q1/6K1 b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be false
      end
    end

    context 'when king is not in check and has legal moves' do
      it 'returns false for starting position' do
        board = Chess::Board.start_positions(add_pieces: true)
        result = validator.stalemate?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(result).to be false
      end

      it 'returns false when king has escape squares' do
        board = Chess::Board.from_fen('k7/8/1K6/8/8/8/8/7R b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be false
      end
    end

    context 'when king is in checkmate' do
      it 'returns false when king is cornered into checkmate' do
        board = Chess::Board.from_fen('6rk/6p1/7R/8/8/8/8/7K b - - 0 1')
        king_pos = board.find_king(Chess::ChessNotation::BLACK_PLAYER)
        in_check = Chess::CheckDetector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER, king_pos)
        puts "King position: #{king_pos}"
        puts "King in check: #{in_check}"
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        puts "Stalemate result: #{result}"
        expect(result).to be false
      end

      it 'returns false for king vs queen in checkmate' do
        board = Chess::Board.from_fen('7k/6Q1/6K1/8/8/8/8/8 b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be false
      end
    end

    context 'when stalemate conditions are met' do
      it 'returns true when king is cornered into stalemate' do
        board = Chess::Board.from_fen('7k/6R1/6K1/8/8/8/8/8 b - - 0 1')
        king_pos = board.find_king(Chess::ChessNotation::BLACK_PLAYER)
        in_check = Chess::CheckDetector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER, king_pos)
        puts "King position: #{king_pos}"
        puts "King in check: #{in_check}"
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        puts "Stalemate result: #{result}"
        expect(result).to be true
      end

      it 'returns true for classic stalemate position where white king is trapped' do
        board = Chess::Board.from_fen('8/8/8/8/8/6q1/5k2/7K w - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(result).to be true
      end

      it 'returns true for pawn stalemate position' do
        board = Chess::Board.from_fen('k7/P7/K7/8/8/8/8/8 b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be true
      end
    end
  end
end
