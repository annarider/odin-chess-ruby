# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for Check Detector

describe Chess::CheckDetector do
  subject(:detector) { described_class }

  let(:board) { Chess::Board.start_positions(add_pieces: true) }

  describe '.in_check?' do
    context 'when starting a new game and king is not in check' do
      it 'returns false for white king' do
        white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(white_check).to be false
      end

      it 'returns false for black king' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be false
      end
    end
    context 'when white king is in check by queen' do
      # Scholar's mate position: king in check by queen on f7
      let(:board) { Chess::Board.from_fen('rnb1kbnr/pppp1ppp/8/4p3/2B1P3/8/PPPP1qPP/RNBQK1NR w KQkq - 2 3') }

      it 'returns true for white king' do
        white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(white_check).to be true
      end
      it 'returns false for black king' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be false
      end
    end

    context 'when black king is in check by rook' do
      # Black king in check by white rook on e8
      let(:board) { Chess::Board.from_fen('rnbqk2R/ppppppbp/6pn/8/8/8/PPPPPPPP/RNBQKBN1 b Qq - 0 4') }

      it 'returns true for black king' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be true
      end
      it 'returns false for white king' do
        white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(white_check).to be false
      end
    end

    context 'when white king is in check by black  bishop' do
      # White king in check by black bishop on diagonal
      let(:bishop_start) { Chess::Position.from_algebraic('f8') }
      let(:bishop_end) { Chess::Position.from_algebraic('a5') }
      before do
        # Move black bishop to attack white king position
        board.update_position(bishop_start, bishop_end)
      end
      it 'returns true for white king' do
        white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(white_check).to be true
      end
      it 'returns false for black king' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be false
      end
    end
  end
end
