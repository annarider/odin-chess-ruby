# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Board class

describe Chess::Board do
  subject(:start_board) { described_class.initial_start }

  let(:first_rank) { 7 }
  let(:second_rank) { 6 }
  let(:seventh_rank) { 1 }
  let(:eighth_rank) { 0 }
  let(:a_file) { 0 }
  let(:c_file) { 2 }
  let(:e_file) { 4 }
  let(:h_file) { 7 }
  let(:starting_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

  describe '.initial_start' do
    context 'when the board is created' do
      it 'adds white pawns to the second rank (row)' do
        initial_position = Chess::Position.from_algebraic('a2')
        expect(start_board.piece_at(initial_position)).to eq('P')
      end

      it 'adds white rooks' do
        initial_pos_queenside = Chess::Position.from_coordinates(first_rank, a_file)
        initial_pos_kingside = Chess::Position.from_coordinates(first_rank, h_file)
        expect(start_board.piece_at(initial_pos_queenside)).to eq('R')
        expect(start_board.piece_at(initial_pos_kingside)).to eq('R')
      end

      it 'adds white king' do
        initial_position = Chess::Position.from_coordinates(first_rank, e_file)
        expect(start_board.piece_at(initial_position)).to eq('K')
      end

      it 'adds black pawns to the 7th rank (row)' do
        initial_position = Chess::Position.from_algebraic('a7')
        expect(start_board.piece_at(initial_position)).to eq('p')
      end

      it 'adds black king' do
        initial_position = Chess::Position.from_coordinates(eighth_rank, e_file)
        expect(start_board.piece_at(initial_position)).to eq('k')
      end

      it 'adds a black bishop' do
        initial_position = Chess::Position.from_coordinates(eighth_rank, c_file)
        expect(start_board.piece_at(initial_position)).to eq('b')
      end

      it 'returns white as the active player color' do
        current_player = start_board.active_color
        expect(current_player).to eq('w')
      end
      it 'returns starting position fen string' do
        result = start_board.to_fen
        expect(result).to eq(starting_fen)
      end
    end
  end

  describe '.from_fen' do
    context 'when creating a new board from a fen string' do
      subject(:starting_board) { described_class.from_fen(starting_fen) }

      let(:starting_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      it 'returns a white pawn at a2' do
        white_pawn_pos = Chess::Position.from_algebraic('a2')
        expect(starting_board.piece_at(white_pawn_pos)).to eq('P')
      end

      it 'returns a black king at e8' do
        black_king_pos = Chess::Position.from_algebraic('e8')
        expect(starting_board.piece_at(black_king_pos)).to eq('k')
      end
      it 'returns white move' do
        result = starting_board.active_color
        expect(result).to eq('w')
      end
      it 'returns all pieces have castling rights' do
        expect(starting_board.white_castle_kingside).to be true
        expect(starting_board.white_castle_queenside).to be true
        expect(starting_board.black_castle_kingside).to be true
        expect(starting_board.black_castle_queenside).to be true
      end
      it 'returns - for en passant square' do
        expect(starting_board.en_passant_square).to eq('-')
      end
      it 'returns 0 for half move clock' do
        expect(starting_board.half_move_clock).to eq(0)
      end
      it 'returns 1 for full move number' do
        expect(starting_board.full_move_number).to eq(1)
      end
    end
    context 'when starting a midway game from fen' do
        let(:after_move_fen) { 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1' }
        subject(:mid_game_board) { described_class.from_fen(after_move_fen) }
      it 'returns a white pawn at e4' do
        white_pawn_pos = Chess::Position.from_algebraic('e4')
        expect(mid_game_board.piece_at(white_pawn_pos)).to eq('P')
      end  

      it 'returns active player color is black' do
        expect(mid_game_board.active_color).to eq('b')
      end

      it 'returns true for all 4 castling rights' do
        expect(mid_game_board.white_castle_kingside).to be true
        expect(mid_game_board.white_castle_queenside).to be true
        expect(mid_game_board.black_castle_kingside).to be true
        expect(mid_game_board.black_castle_queenside).to be true        
      end
      it 'returns e3 for en passant square' do
        en_passant_pos = Chess::Position.from_algebraic('e3')
        expect(mid_game_board.en_passant_square).to eq(en_passant_pos)
      end

      it 'returns 0 for half move clock' do
        expect(mid_game_board.half_move_clock).to eq(0)
      end
      it 'returns 1 for full move number' do
        expect(mid_game_board.full_move_number).to eq(1)
      end
    end
  end

  describe '#to_display' do
    context 'when starting a new game' do
      it 'returns a display string with the same number of lines as the grid board' do
        result = start_board.to_display
        expect(result).to be_an(Array)
        expect(result.size).to eq(Chess::Config::GRID_LENGTH)
      end
    end
  end

  describe '#to_fen' do
    context 'when starting a new game' do
      it 'returns the fen piece placement data in the correct order' do
        result = start_board.to_fen
        starting_fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
        expect(result).to eq(starting_fen)
      end
    end
    context 'when creating FEN from a midway game' do
      it 'returns ' do
        
      end
    end
  end
end
