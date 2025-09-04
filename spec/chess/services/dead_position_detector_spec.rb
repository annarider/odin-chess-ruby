# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::DeadPositionDetector do
  subject(:detector) { described_class }

  describe '.dead_position?' do
    context 'when there is sufficient material for checkmate' do
      it 'returns false for starting position' do
        board = Chess::Board.start_positions(add_pieces: true)

        result = detector.dead_position?(board)

        expect(result).to be false
      end

      it 'returns false when white has queen and king vs black king' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('d1'), 'Q')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')

        result = detector.dead_position?(board)

        expect(result).to be false
      end

      it 'returns false when white has rook and king vs black king' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('a1'), 'R')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')

        result = detector.dead_position?(board)

        expect(result).to be false
      end

      it 'returns false when white has pawn and king vs black king' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('e2'), 'P')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')

        result = detector.dead_position?(board)

        expect(result).to be false
      end

      it 'returns false when both sides have bishops on different colored squares' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('c1'), 'B') # light square
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
        board.place_piece(Chess::Position.from_algebraic('c8'), 'b') # dark square

        result = detector.dead_position?(board)

        expect(result).to be false
      end
    end

    context 'when material is insufficient for checkmate' do
      it 'returns true for king vs king' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')

        result = detector.dead_position?(board)

        expect(result).to be true
      end

      it 'returns true for king and bishop vs king' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('c1'), 'B')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')

        result = detector.dead_position?(board)

        expect(result).to be true
      end

      it 'returns true for king and knight vs king' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('b1'), 'N')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')

        result = detector.dead_position?(board)

        expect(result).to be true
      end

      it 'returns true for king vs king and bishop' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
        board.place_piece(Chess::Position.from_algebraic('c8'), 'b')

        result = detector.dead_position?(board)

        expect(result).to be true
      end

      it 'returns true for king vs king and knight' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
        board.place_piece(Chess::Position.from_algebraic('b8'), 'n')

        result = detector.dead_position?(board)

        expect(result).to be true
      end

      it 'returns true for king and bishop vs king and bishop on same colored squares' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('c1'), 'B') # light square (0+2=2, even)
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
        board.place_piece(Chess::Position.from_algebraic('a1'), 'b') # light square (0+0=0, even)

        result = detector.dead_position?(board)

        expect(result).to be true
      end
    end

    context 'when testing edge cases with multiple pieces' do
      it 'returns false when white has two knights vs black king' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('b1'), 'N')
        board.place_piece(Chess::Position.from_algebraic('g1'), 'N')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')

        result = detector.dead_position?(board)

        expect(result).to be false
      end

      it 'returns false when white has bishop and knight vs black king' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('c1'), 'B')
        board.place_piece(Chess::Position.from_algebraic('b1'), 'N')
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')

        result = detector.dead_position?(board)

        expect(result).to be false
      end
    end

    context 'when testing square color calculations' do
      it 'correctly identifies same colored squares for bishops' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('a1'), 'B') # dark square
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
        board.place_piece(Chess::Position.from_algebraic('h8'), 'b') # dark square

        result = detector.dead_position?(board)

        expect(result).to be true
      end

      it 'correctly identifies different colored squares for bishops' do
        board = Chess::Board.new
        board.place_piece(Chess::Position.from_algebraic('e1'), 'K')
        board.place_piece(Chess::Position.from_algebraic('a1'), 'B') # dark square
        board.place_piece(Chess::Position.from_algebraic('e8'), 'k')
        board.place_piece(Chess::Position.from_algebraic('a8'), 'b') # light square

        result = detector.dead_position?(board)

        expect(result).to be false
      end
    end

    context 'when testing realistic endgame scenarios' do
      it 'returns true for drawn king and bishop vs king and bishop endgame' do
        board = Chess::Board.from_fen('8/8/8/3k4/8/3K4/4B3/8 w - - 0 50')
        result = detector.dead_position?(board)
        expect(result).to be true
      end

      it 'returns true for drawn king and knight vs king endgame' do
        board = Chess::Board.from_fen('8/8/8/3k4/8/3KN3/8/8 w - - 0 50')

        result = detector.dead_position?(board)

        expect(result).to be true
      end
    end

    describe 'integration with board state' do
      it 'works with FEN positions for insufficient material' do
        # King and bishop vs king - insufficient
        board = Chess::Board.from_fen('8/8/8/3k4/8/3KB3/8/8 w - - 0 50')

        result = detector.dead_position?(board)

        expect(result).to be true
      end

      it 'works with FEN positions for sufficient material' do
        # King and queen vs king - sufficient
        board = Chess::Board.from_fen('8/8/8/3k4/8/3KQ3/8/8 w - - 0 50')

        result = detector.dead_position?(board)

        expect(result).to be false
      end
    end
  end

  describe '#dead_position?' do
    it 'delegates to class method' do
      board = Chess::Board.new
      described_class.new(board)

      expect(described_class).to receive(:dead_position?).with(board)
      described_class.dead_position?(board)
    end
  end
end
