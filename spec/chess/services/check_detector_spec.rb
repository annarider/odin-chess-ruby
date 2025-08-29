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

    context 'when black bishop attack is blocked by pawn' do
      # Black bishop on a5 cannot check white king due to pawn on d2 blocking diagonal
      let(:bishop_start) { Chess::Position.from_algebraic('f8') }
      let(:bishop_end) { Chess::Position.from_algebraic('a5') }

      before do
        # Move black bishop to a5 (attack blocked by d2 pawn)
        board.update_position(bishop_start, bishop_end)
      end

      it 'returns false for white king when attack is blocked' do
        white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(white_check).to be false
      end

      it 'returns false for black king' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be false
      end
    end

    context 'when king is in check by knight' do
      let(:board) { Chess::Board.from_fen('rnbqkb1r/pppppppp/5n2/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 1 2') }

      before do
        # Place white king on e4 and black knight on f6 to create check conditions
        board.place_piece(Chess::Position.from_algebraic('e4'), 'K')
        board.place_piece(Chess::Position.from_algebraic('f6'), 'n')
      end

      it 'returns true for white king in check' do
        white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(white_check).to be true
      end
    end

    context 'when white king is in check by black pawn' do
      # Create position with white king on e5 and black pawn on d6 to set up check
      let(:board) { Chess::Board.from_fen('rnbqkbnr/ppp1pppp/3p4/4K3/8/8/PPPPPPPP/RNBQ1BNR w KQkq - 0 1') }

      it 'returns true for white king in check' do
        white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(white_check).to be true
      end
    end

    context 'when pieces are blocking potential check' do
      # Rook attack blocked by another piece
      let(:board) { Chess::Board.from_fen('r3k3/8/8/8/8/8/4P3/4K3 w - - 0 1') }

      it 'returns false for white king when rook attack is blocked' do
        white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(white_check).to be false
      end
    end

    context 'edge cases' do
      let(:empty_board) { Chess::Board.new }

      context 'when no king on the board' do
        it 'returns false for black king' do
          black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
          expect(black_check).to be false
        end
      end

      context 'when no opponent pieces on the board' do
        before do
          # Only white king, no other pieces
          board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        end

        it 'returns false for white king' do
          white_check = detector.in_check?(board, Chess::ChessNotation::WHITE_PLAYER)
          expect(white_check).to be false
        end
      end
    end

    context 'when black king is in complex check situation' do
      # Fischer vs Byrne 1956, position after queen sacrifice
      let(:board) { Chess::Board.from_fen('r3r1k1/pp3ppp/1qn2n2/3p1b2/3P1B2/2N2N2/PP2QPPP/2RR2K1 b - - 0 18') }

      it 'returns false when it correctly detects black king is not in check' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be false
      end
    end

    context 'when back rank mate set up puts black king in check' do
      # Rook creates a back rank check
      let(:board) { Chess::Board.from_fen('6k1/5ppp/8/8/8/8/5PPP/4R1K1 b - - 0 1') }

      before do
        board.place_piece(Chess::Position.from_algebraic('e8'), 'R')
      end

      it 'returns true as it identifies check before mate' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be true
      end
    end

    context 'when endgame has black king under check from white king & queen' do
      # King and queen vs king endgame
      let(:board) { Chess::Board.from_fen('8/8/8/8/8/4k3/2Q5/4K3 w - - 0 1') }

      it 'returns false correctly when black king is not yet in check in endgame' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be false
      end

      it 'returns true correctly after queen moves and king comes under check' do
        # Set up white queen in position to attack black king
        board.update_position(
          Chess::Position.from_algebraic('c2'),
          Chess::Position.from_algebraic('d2')
        )
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be true
      end
    end
  end

  describe '#initialize' do
    context "when the king's position is provided at the start of the game" do
      it "returns false when using the king's position which is passed in" do
        king_start = Chess::Position.new(3, 4)
        black_check = detector.in_check?(
          board,
          Chess::ChessNotation::BLACK_PLAYER,
          king_start
        )
        expect(black_check).to be false
      end
    end

    context "when the king's position isn't provided" do
      it 'returns false for black king' do
        black_check = detector.in_check?(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(black_check).to be false
      end
    end

    context "when the king's position is explicitly passed in as nil" do
      it 'returns false for black king' do
        black_check = detector.in_check?(
          board,
          Chess::ChessNotation::BLACK_PLAYER,
          nil
        )
        expect(black_check).to be false
      end
    end

    context "when the white king's position is provided" do
      # Set up a post castling move which puts the king in check
      let(:board) { Chess::Board.from_fen('6r1/8/8/8/8/8/8/4K2R w K - 0 1') }

      it 'returns true when the king is in check' do
        white_check = detector.in_check?(
          board,
          Chess::ChessNotation::WHITE_PLAYER,
          Chess::Position.from_algebraic('g1')
        )
        expect(white_check).to be true
      end
    end
  end
end
