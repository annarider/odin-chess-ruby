# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for Move History class

describe Chess::MoveHistory do
  subject(:history_from_start) { described_class.new }

  describe '#add_move' do
    context 'when the first move completes' do
      let(:knight_start) { Chess::Position.from_algebraic('b1') }
      let(:knight_destination) { Chess::Position.from_algebraic('c3') }
      let(:fen) { 'rnbqkbnr/pppppppp/8/8/8/2N5/PPPPPPPP/R1BQKBNR b KQkq - 1 1' }
      let(:knight_move) do
        Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N', fen: fen)
      end

      it 'increases the move count by 1' do
        expect { history_from_start.add_move(knight_move) }.to change(history_from_start, :count_moves).by(1)
      end

      it 'return false for threefold repetition?' do
        history_from_start.add_move(knight_move)
        result = history_from_start.threefold_repetition?
        expect(result).to be false
      end
    end
  end

  describe '#threefold_repetition?' do
    context 'when no position repeats three times' do
      it 'returns false for normal game progression' do
        normal_game_fens = [
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
          'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
          'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2',
          'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          'r1bqkbnr/pp1ppppp/2n5/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3',
          'r1bqkbnr/pp1ppppp/2n5/2p5/3PP3/5N2/PPP2PPP/RNBQKB1R b KQkq d3 0 3'
        ]
        normal_game_fens.each { |fen| history_from_start.add_to_position(fen) }
        result = history_from_start.threefold_repetition?
        expect(result).to be false
      end
    end
    context 'when Polgar vs. Kasparov, 2002 led to perpetual check draw' do
      it 'returns true for threefold repetition' do
        threefold_repetition_fens = [
          '2r3k1/5pp1/3p3p/3Pp3/1p2P1P1/1P2BP2/5P1P/4R1K1 w - - 0 30',
          '2r3k1/5pp1/3p3p/3Pp3/1p2P1P1/1P2BP2/4QP1P/4R1K1 b - - 1 30',
          '2r5/4kpp1/3p3p/3Pp3/1p2P1P1/1P2BP2/4QP1P/4R1K1 w - - 2 31',
          '2r5/4kpp1/3p3p/3Pp2Q/1p2P1P1/1P2BP2/5P1P/4R1K1 b - - 3 31',
          '2r3k1/5pp1/3p3p/3Pp2Q/1p2P1P1/1P2BP2/5P1P/4R1K1 w - - 4 32',
          '2r3k1/5pp1/3p3p/3Pp3/1p2P1P1/1P2BP2/4QP1P/4R1K1 b - - 5 32',
          '2r5/4kpp1/3p3p/3Pp3/1p2P1P1/1P2BP2/4QP1P/4R1K1 w - - 6 33',
          '2r5/4kpp1/3p3p/3Pp2Q/1p2P1P1/1P2BP2/5P1P/4R1K1 b - - 7 33',
          '2r3k1/5pp1/3p3p/3Pp2Q/1p2P1P1/1P2BP2/5P1P/4R1K1 w - - 8 34',
          '2r3k1/5pp1/3p3p/3Pp3/1p2P1P1/1P2BP2/4QP1P/4R1K1 b - - 9 34',
          '2r5/4kpp1/3p3p/3Pp3/1p2P1P1/1P2BP2/4QP1P/4R1K1 w - - 10 35',
          '2r5/4kpp1/3p3p/3Pp2Q/1p2P1P1/1P2BP2/5P1P/4R1K1 b - - 11 35'
        ]
        threefold_repetition_fens.each { |fen| history_from_start.add_to_position(fen) }
        expect(history_from_start.threefold_repetition?).to be true
      end
    end
    context 'when knights position repeats leading to draw' do
      it 'returns true for threefold repetition' do
        fens_knight_repetition = [
          'r1bq1rk1/pp2nppp/2n1p3/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 0 10',
          'r1bq1rk1/pp2nppp/2n1p3/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R b KQ - 1 10',
          'r1bq1rk1/pp2nppp/4p3/1n1p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 2 11',
          'r1bq1rk1/pp2nppp/4p3/1n1p4/2PP4/4PN2/PP1NBPPP/R1BQK2R b KQ - 3 11',
          'r1bq1rk1/pp2nppp/2n1p3/3p4/2PP4/4PN2/PP1NBPPP/R1BQK2R w KQ - 4 12',
          'r1bq1rk1/pp2nppp/2n1p3/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R b KQ - 5 12',
          'r1bq1rk1/pp2nppp/4p3/1n1p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 6 13',
          'r1bq1rk1/pp2nppp/4p3/1n1p4/2PP4/4PN2/PP1NBPPP/R1BQK2R b KQ - 7 13',
          'r1bq1rk1/pp2nppp/2n1p3/3p4/2PP4/4PN2/PP1NBPPP/R1BQK2R w KQ - 8 14',
          'r1bq1rk1/pp2nppp/2n1p3/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R b KQ - 9 14',
          'r1bq1rk1/pp2nppp/4p3/1n1p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 10 15',
          'r1bq1rk1/pp2nppp/4p3/1n1p4/2PP4/4PN2/PP1NBPPP/R1BQK2R b KQ - 11 15'
        ]
        fens_knight_repetition.each { |fen| history_from_start.add_to_position(fen) }
        expect(history_from_start.threefold_repetition?).to be true
      end
    end
  end

  describe '#has_moved?' do
    context 'when the game starts and no piece has moved' do
      let(:start_board) { Chess::Board.initial_start(add_pieces: true) }
      it 'returns false for white pawn' do
        start_pos = Chess::Position.from_algebraic('d2')
        expect(history_from_start.has_moved?(start_pos)).to be false
      end
      it 'returns false for black king' do
        start_pos = Chess::Position.from_algebraic('e8')
        expect(history_from_start.has_moved?(start_pos)).to be false
      end
    end
    context 'when a white pawn has moved and no other pieces have moved' do
      let(:mid_game_board) { Chess::Board.initial_start(add_pieces: true) }
      before do 
        
      end
      it 'returns true for the white pawn' do
        start_pos = Chess::Position.from_algebraic('d2')

      end
    end
  end
end
