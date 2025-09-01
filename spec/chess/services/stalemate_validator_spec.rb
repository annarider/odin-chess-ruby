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

    context 'when king is not in check but has legal moves' do
      it 'returns false for starting position' do
        board = Chess::Board.start_positions(add_pieces: true)
        result = validator.stalemate?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(result).to be false
      end

      it 'returns false when king has escape squares' do
        board = Chess::Board.from_fen('8/8/8/8/8/8/6k1/6K1 b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be false
      end

      it 'returns false when other pieces have legal moves' do
        board = Chess::Board.from_fen('8/8/8/8/8/6p1/6k1/6K1 b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be false
      end
    end

    context 'when stalemate conditions are met' do
      it 'returns true for classic stalemate position' do
        board = Chess::Board.from_fen('8/8/8/8/8/5Q2/5K2/5k2 b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be true
      end

      it 'returns true for king vs queen stalemate' do
        board = Chess::Board.from_fen('7k/6Q1/6K1/8/8/8/8/8 b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be true
      end

      it 'returns true for pawn stalemate position' do
        board = Chess::Board.from_fen('8/8/8/8/8/5p2/4pP2/4Kk2 b - - 0 1')
        result = validator.stalemate?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(result).to be true
      end
    end
  end
end