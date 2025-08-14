# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Chess Board class

describe Chess::Board do
  subject(:start_board) { described_class.start_positions }

  let(:first_rank) { 7 }
  let(:second_rank) { 6 }
  let(:seventh_rank) { 1 }
  let(:eighth_rank) { 0 }
  let(:a_file) { 0 }
  let(:c_file) { 2 }
  let(:e_file) { 4 }
  let(:h_file) { 7 }

  describe '.start_positions' do
    context 'when the board is created' do
      it 'adds white pawns to the second rank (row)' do
        start_pos = Chess::Position.from_algebraic('a2')
        expect(start_board.piece_at(start_pos)).to eq('P')
      end

      it 'adds white rooks' do
        initial_pos_queenside = Chess::Position.from_coordinates(first_rank, a_file)
        initial_pos_kingside = Chess::Position.from_coordinates(first_rank, h_file)
        expect(start_board.piece_at(initial_pos_queenside)).to eq('R')
        expect(start_board.piece_at(initial_pos_kingside)).to eq('R')
      end

      it 'adds white king' do
        start_pos = Chess::Position.from_coordinates(first_rank, e_file)
        expect(start_board.piece_at(start_pos)).to eq('K')
      end

      it 'adds black pawns to the 7th rank (row)' do
        start_pos = Chess::Position.from_algebraic('a7')
        expect(start_board.piece_at(start_pos)).to eq('p')
      end

      it 'adds black king' do
        start_pos = Chess::Position.from_coordinates(eighth_rank, e_file)
        expect(start_board.piece_at(start_pos)).to eq('k')
      end

      it 'adds a black bishop' do
        start_pos = Chess::Position.from_coordinates(eighth_rank, c_file)
        expect(start_board.piece_at(start_pos)).to eq('b')
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

      it 'returns all pieces have castling rights' do
        expect(starting_board.castling_rights.values).to all(be true)
      end

      it 'returns nil for en passant square' do
        expect(starting_board.en_passant_square).to be_nil
      end
    end

    context 'when starting a midway game from fen' do
      subject(:mid_game_board) { described_class.from_fen(after_move_fen) }

      let(:after_move_fen) { 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1' }

      it 'returns a white pawn at e4' do
        white_pawn_pos = Chess::Position.from_algebraic('e4')
        expect(mid_game_board.piece_at(white_pawn_pos)).to eq('P')
      end

      it 'returns true for all 4 castling rights' do
        expect(mid_game_board.castling_rights.values).to all(be true)
      end

      it 'returns e3 for en passant square' do
        en_passant_pos = Chess::Position.from_algebraic('e3')
        expect(mid_game_board.en_passant_square).to eq(en_passant_pos)
      end
    end

    context 'when loading an end game from fen' do
      subject(:end_game_board) { described_class.from_fen(end_game_fen) }

      let(:end_game_fen) { '3B4/K7/2k1b1p1/1p2Pp1p/3P3P/2P3P1/8/8 w - - 0 74' }

      it 'returns a white king at a7' do
        white_king_pos = Chess::Position.from_algebraic('a7')
        expect(end_game_board.piece_at(white_king_pos)).to eq('K')
      end

      it 'returns false for all 4 castling rights' do
        expect(end_game_board.castling_rights.values).to all(be false)
      end

      it 'returns nil for en passant square' do
        expect(end_game_board.en_passant_square).to be_nil
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

  describe '#piece_at' do
    context 'when the white rook is at h1' do
      let(:rook_position) { Chess::Position.from_algebraic('h1') }

      it 'returns R, the symbol for white rook' do
        result = start_board.piece_at(rook_position)
        expect(result).to eq('R')
      end
    end

    context 'when there is an empty square at d4' do
      let(:empty_square) { Chess::Position.from_algebraic('d4') }

      it 'returns nil' do
        result = start_board.piece_at(empty_square)
        expect(result).to be_nil
      end
    end
  end

  describe '#update_position' do
    context 'when moving a white pawn to an empty square' do
      let(:start_pos) { Chess::Position.from_algebraic('d2') }
      let(:end_pos) { Chess::Position.from_algebraic('d3') }

      it 'places the piece at the destination' do
        original_piece = start_board.piece_at(start_pos)
        start_board.update_position(start_pos, end_pos)
        expect(start_board.piece_at(end_pos)).to eq(original_piece)
      end

      it 'removes the piece from the origin position' do
        start_board.update_position(start_pos, end_pos)
        expect(start_board.piece_at(start_pos)).to be_nil
      end
    end

    context 'when capturing an opponent piece' do
      let(:attacker_pos) { Chess::Position.new(1, 0) }
      let(:target_pos) { Chess::Position.new(6, 0) }

      it 'replaces the target piece with the attacking piece' do
        attacking_piece = start_board.piece_at(attacker_pos)
        start_board.update_position(attacker_pos, target_pos)
        expect(start_board.piece_at(target_pos)).to eq(attacking_piece)
      end
    end
  end

  describe '#valid_move?' do
    let(:knight_start) { Chess::Position.from_algebraic('d5') }
    let(:knight_destination) { Chess::Position.from_algebraic('c3') }
    let(:move) { Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N') }

    it 'delegates to MoveValidator' do
      expect(Chess::MoveValidator).to receive(:move_legal?).with(start_board, move)
      start_board.valid_move?(move)
    end
  end
end
