# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Chess Board class

describe Chess::Board do
  subject(:start_board) { described_class.start_positions }

  describe '.start_positions' do
    context 'when the board is created' do
      let(:first_rank) { 7 }
      let(:second_rank) { 6 }
      let(:seventh_rank) { 1 }
      let(:eighth_rank) { 0 }
      let(:a_file) { 0 }
      let(:c_file) { 2 }
      let(:e_file) { 4 }
      let(:h_file) { 7 }

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
        expect(starting_board.en_passant_target).to be_nil
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
        expect(mid_game_board.en_passant_target).to eq(en_passant_pos)
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
        expect(end_game_board.en_passant_target).to be_nil
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
      allow(Chess::MoveValidator).to receive(:move_legal?)
        .with(start_board, move)
      start_board.valid_move?(move)
      expect(Chess::MoveValidator).to have_received(:move_legal?)
    end
  end

  describe '#find_king' do
    context 'when starting a new game' do
      it 'returns e1 for white king' do
        expected_position = Chess::Position.from_algebraic('e1')
        expect(start_board.find_king(Chess::ChessNotation::WHITE_PLAYER)).to eq(expected_position)
      end

      it 'returns e8 for black king' do
        expected_position = Chess::Position.from_algebraic('e8')
        expect(start_board.find_king(Chess::ChessNotation::BLACK_PLAYER)).to eq(expected_position)
      end
    end

    context 'when placing a black king on e6' do
      start_pos = Chess::Position.from_algebraic('e8')
      end_pos = Chess::Position.from_algebraic('e6')
      before do
        start_board.update_position(start_pos, end_pos)
      end

      it 'returns e6 for moved black king' do
        expect(start_board.find_king(Chess::ChessNotation::BLACK_PLAYER)).to eq(end_pos)
      end
    end
  end

  describe '#find_all_pieces' do
    context "when starting a new game (which starts as white's move)" do
      it 'returns all black pieces with positions' do
        expected_positions = starting_positions(Chess::ChessNotation::BLACK_PLAYER)
        actual_positions = start_board.find_all_pieces(Chess::ChessNotation::BLACK_PLAYER)
                                      .map { |data| data[:position] }
        expect(actual_positions).to match_array(expected_positions)
      end

      context 'when the game has pieces in starting positions' do
        it "returns all white pieces when it is black's move" do
          expected_positions = starting_positions(Chess::ChessNotation::WHITE_PLAYER)
          actual_positions = start_board.find_all_pieces(Chess::ChessNotation::WHITE_PLAYER)
                                        .map { |data| data[:position] }
          expect(actual_positions).to match_array(expected_positions)
        end
      end

      context 'when all black pieces are requested' do
        it 'returns only black pieces' do
          black_pieces = start_board.find_all_pieces(Chess::ChessNotation::BLACK_PLAYER)
          expect(black_pieces.length).to eq(16)
          expect(black_pieces.map { |data| data[:piece] }).to all(match(/[a-z]/))
        end
      end

      context 'when all white pieces are requested' do
        it 'returns only white pieces' do
          white_pieces = start_board.find_all_pieces(Chess::ChessNotation::WHITE_PLAYER)
          expect(white_pieces.length).to eq(16)
          expect(white_pieces.map { |data| data[:piece] }).to all(match(/[A-Z]/))
        end
      end
    end

    describe '#deep_copy' do
      context 'when board has all starting pieces in a new game' do
        it 'returns a different object compared to original board' do
          board_copy = start_board.deep_copy
          expect(board_copy).not_to be(start_board)
        end
        it 'returns the same data as the original board' do          
          board_copy = start_board.deep_copy
          expect(board_copy.to_fen).to eq(start_board.to_fen)
        end
      end
      context 'when copying a mid game' do
        let(:original_board) { described_class.from_fen('r3k2r/8/8/8/8/8/8/R3K2R w KQkq e3 0 1') }
         it 'creates independent copy of grid' do
          copy = original_board.deep_copy
          original_board.place_piece(Chess::Position.from_algebraic('e4'), 'Q')
          expect(copy.piece_at(Chess::Position.from_algebraic('e4'))).to be_nil
        end

        it 'copies castling rights independently' do
          copy = original_board.deep_copy
          original_board.castling_rights[:white_castle_kingside] = false

          expect(copy.castling_rights[:white_castle_kingside]).to be true
        end

        it 'copies en passant target independently' do
          copy = original_board.deep_copy
          original_board.en_passant_target = Chess::Position.from_algebraic('d6')

          expect(copy.en_passant_target).to eq(Chess::Position.from_algebraic('e3'))
        end

        it 'maintains all piece positions accurately' do
          copy = original_board.deep_copy

          expect(copy.piece_at(Chess::Position.from_algebraic('e1'))).to eq('K')
          expect(copy.piece_at(Chess::Position.from_algebraic('e8'))).to eq('k')
          expect(copy.piece_at(Chess::Position.from_algebraic('a1'))).to eq('R')
        end

        it 'creates completely independent board' do
          copy = original_board.deep_copy

          # Modify original
          original_board.update_position(
            Chess::Position.from_algebraic('e1'),
            Chess::Position.from_algebraic('f1')
          )

          # Copy should be unchanged
          expect(copy.piece_at(Chess::Position.from_algebraic('e1'))).to eq('K')
          expect(copy.piece_at(Chess::Position.from_algebraic('f1'))).to be_nil
        end
      end
    end

    private

    def starting_positions(active_color)
      regex = active_color == Chess::ChessNotation::WHITE_PLAYER ? /[A-Z]/ : /[a-z]/
      # Use existing Piece data about starting positions
      Chess::Piece::START_POSITIONS.select { |_, symbol| symbol.match?(regex) }
                                   .keys # gets the position info in array
                                   .map { |pos| Chess::Position.new(pos.first, pos.last) }
    end

    def positions_for_color(board, active_color)
      board.find_all_pieces(active_color)
           .map { |data| Chess::Position.new(data[:position].first, data[:position].last) }
    end
  end
end
