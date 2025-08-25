# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for Checkmate Detector

describe Chess::CheckmateDetector do
  subject(:detector) { described_class.new(board, active_color) }

  let(:board) { Chess::Board.start_positions(add_pieces: true) }
  let(:active_color) { Chess::ChessNotation::WHITE_PLAYER }

  describe '.checkmate?' do
    context 'when using class method' do
      it 'delegates to instance method' do
        expect(described_class.checkmate?(board, active_color)).to be false
      end
    end
  end

  describe '#initialize' do
    context 'when king position is not provided' do
      it 'locates the king automatically' do
        expect(detector.board).to eq(board)
        expect(detector.instance_variable_get(:@active_color)).to eq(active_color)
        expect(detector.instance_variable_get(:@king_position)).to be_a(Chess::Position)
      end
    end

    context 'when king position is provided' do
      let(:king_position) { Chess::Position.from_algebraic('e1') }
      subject(:detector) { described_class.new(board, active_color, king_position) }

      it 'uses the provided king position' do
        expect(detector.instance_variable_get(:@king_position)).to eq(king_position)
      end
    end
  end

  describe '#checkmate?' do
    context 'when king is not in check' do
      let(:board) { Chess::Board.start_positions(add_pieces: true) }

      it 'returns false for white king' do
        detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(detector.checkmate?).to be false
      end

      it 'returns false for black king' do
        detector = described_class.new(board, Chess::ChessNotation::BLACK_PLAYER)
        expect(detector.checkmate?).to be false
      end
    end

    context 'when king is in check but can evade' do
      # Queen giving check but king can move
      let(:board) { Chess::Board.from_fen('rnb1kbnr/pppp1ppp/8/4p3/2B1P3/8/PPPP1qPP/RNBQK1NR w KQkq - 2 3') }

      it 'returns false when king can move to safety' do
        detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(detector.checkmate?).to be false
      end
    end

    context 'when king is in check but attacker can be captured' do
      # Set up position where attacking piece can be captured
      let(:board) { Chess::Board.from_fen('rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1qPP/RNBQKBNR w KQkq - 2 3') }

      before do
        # Place white queen to capture attacking black queen
        board.place_piece(Chess::Position.from_algebraic('d1'), 'Q')
      end

      it 'returns false when attacking piece can be captured' do
        detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(detector.checkmate?).to be false
      end
    end

    context 'classic checkmate scenarios' do
      context 'fools mate - fastest checkmate' do
        let(:board) { Chess::Board.from_fen('rnb1kbnr/pppp1ppp/8/4p3/6Pq/8/PPPPP2P/RNBQKBNR w KQkq - 1 3') }

        it 'returns true for white king in checkmate' do
          detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER)
          expect(detector.checkmate?).to be true
        end
      end

      context 'scholars mate' do
        let(:board) { Chess::Board.from_fen('r1bqkb1r/pppp1Qpp/2n2n2/4p3/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 4') }

        it 'returns true for black king in checkmate' do
          detector = described_class.new(board, Chess::ChessNotation::BLACK_PLAYER)
          expect(detector.checkmate?).to be true
        end
      end

      context 'back rank mate' do
        let(:board) { Chess::Board.from_fen('6k1/5ppp/8/8/8/8/5PPP/4R1K1 b - - 0 1') }

        before do
          board.place_piece(Chess::Position.from_algebraic('e8'), 'R')
        end

        it 'returns true for black king in checkmate' do
          detector = described_class.new(board, Chess::ChessNotation::BLACK_PLAYER)
          expect(detector.checkmate?).to be true
        end
      end

      context 'queen and king mate' do
        let(:board) { Chess::Board.from_fen('8/8/8/8/8/6k1/8/5QK1 b - - 0 1') }

        it 'returns true for black king in checkmate' do
          detector = described_class.new(board, Chess::ChessNotation::BLACK_PLAYER)
          expect(detector.checkmate?).to be true
        end
      end

      context 'smothered mate' do
        # Knight delivers mate while king is trapped by its own pieces
        let(:board) { Chess::Board.from_fen('6rk/6pp/8/8/8/8/5N2/6K1 b - - 0 1') }

        before do
          board.place_piece(Chess::Position.from_algebraic('f7'), 'N')
        end

        it 'returns true for black king in smothered mate' do
          detector = described_class.new(board, Chess::ChessNotation::BLACK_PLAYER)
          expect(detector.checkmate?).to be true
        end
      end
    end

    context 'stalemate situations' do
      # King not in check but has no legal moves
      let(:board) { Chess::Board.from_fen('8/8/8/8/8/6k1/5q2/5K2 w - - 0 1') }

      it 'returns false for stalemate (king not in check)' do
        detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER)
        expect(detector.checkmate?).to be false
      end
    end

    context 'complex positions' do
      context 'when check can be blocked' do
        let(:board) { Chess::Board.from_fen('r3k3/8/8/8/8/8/4R3/4K3 b - - 0 1') }

        before do
          # Add piece that can block the check
          board.place_piece(Chess::Position.from_algebraic('d8'), 'r')
        end

        it 'returns false when check can be blocked' do
          detector = described_class.new(board, Chess::ChessNotation::BLACK_PLAYER)
          expect(detector.checkmate?).to be false
        end
      end

      context 'discovered check scenarios' do
        let(:board) { Chess::Board.from_fen('r3k3/8/8/3B4/8/8/8/4K3 b - - 0 1') }

        before do
          # Set up discovered check position
          board.place_piece(Chess::Position.from_algebraic('a8'), 'r')
          board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
          board.place_piece(Chess::Position.from_algebraic('a1'), 'R')
        end

        it 'correctly identifies checkmate in discovered check' do
          detector = described_class.new(board, Chess::ChessNotation::BLACK_PLAYER)
          expect(detector.checkmate?).to be true
        end
      end
    end

    context 'edge cases' do
      context 'when no pieces on board' do
        let(:board) { Chess::Board.new }

        it 'returns false when no king exists' do
          detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER)
          expect(detector.checkmate?).to be false
        end
      end

      context 'when only kings on board' do
        let(:board) { Chess::Board.new }

        before do
          board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
          board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
        end

        it 'returns false when only kings present' do
          detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER)
          expect(detector.checkmate?).to be false
        end
      end

      context 'when king position is explicitly provided' do
        let(:board) { Chess::Board.from_fen('rnb1kbnr/pppp1ppp/8/4p3/6Pq/8/PPPPP2P/RNBQKBNR w KQkq - 1 3') }
        let(:king_position) { Chess::Position.from_algebraic('e1') }

        it 'uses provided position for checkmate detection' do
          detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER, king_position)
          expect(detector.checkmate?).to be true
        end
      end
    end

    context 'performance edge cases' do
      context 'endgame positions' do
        let(:board) { Chess::Board.from_fen('8/8/8/8/8/2k5/1q6/2K5 w - - 0 1') }

        it 'efficiently detects checkmate in endgame' do
          detector = described_class.new(board, Chess::ChessNotation::WHITE_PLAYER)
          expect(detector.checkmate?).to be true
        end
      end

      context 'positions with many pieces' do
        let(:board) { Chess::Board.from_fen('r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R b KQkq - 0 4') }

        it 'handles complex positions efficiently' do
          detector = described_class.new(board, Chess::ChessNotation::BLACK_PLAYER)
          expect(detector.checkmate?).to be false
        end
      end
    end
  end
end