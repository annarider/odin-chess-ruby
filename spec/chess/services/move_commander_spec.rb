# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for MoveCommander

describe Chess::MoveCommander do
  describe '.execute_move' do
    # Helper methods to create real Position, Move, and Board objects
    def position(square)
      Chess::Position.from_algebraic(square)
    end

    def create_move(
      from_square:,
      to_square:,
      piece:,
      castling: nil,
      promotion: nil,
      double_pawn_move: nil
    )
      Chess::Move.new(
        from_position: position(from_square),
        to_position: position(to_square),
        piece: piece,
        castling: castling,
        promotion: promotion,
        double_pawn_move: double_pawn_move
      )
    end

    def create_board_with_pieces(piece_positions, en_passant_target: nil)
      board = Chess::Board.empty_grid
      piece_positions.each do |square, piece|
        pos = position(square)
        board[pos.row][pos.column] = piece
      end
      Chess::Board.new(grid: board, en_passant_target: en_passant_target)
    end

    context 'when moving basic pieces' do
      it 'moves a white pawn from e2 to e4' do
        board = create_board_with_pieces({ 'e2' => 'P' })
        move = create_move(from_square: 'e2', to_square: 'e4', piece: 'P')
        described_class.execute_move(board, move)
        expect(board.piece_at(position('e2'))).to be_nil
        expect(board.piece_at(position('e4'))).to eq('P')
      end

      it 'moves a black knight from b8 to c6' do
        board = create_board_with_pieces({ 'b8' => 'n' })
        move = create_move(from_square: 'b8', to_square: 'c6', piece: 'n')
        described_class.execute_move(board, move)
        expect(board.piece_at(position('b8'))).to be_nil
        expect(board.piece_at(position('c6'))).to eq('n')
      end

      it 'captures an opponent piece' do
        board = create_board_with_pieces({ 'e4' => 'P', 'f5' => 'p' })
        move = create_move(from_square: 'e4', to_square: 'f5', piece: 'P')
        described_class.execute_move(board, move)
        expect(board.piece_at(position('e4'))).to be_nil
        expect(board.piece_at(position('f5'))).to eq('P')
      end
    end

    context 'when moving pawns two squares' do
      it 'sets en passant target when white pawn moves from e2 to e4' do
        board = create_board_with_pieces({ 'e2' => 'P' })
        move = create_move(from_square: 'e2', to_square: 'e4', piece: 'P')
        described_class.execute_move(board, move)
        expect(board.en_passant_target).to eq(position('e3'))
      end

      it 'sets en passant target when black pawn moves from d7 to d5' do
        board = create_board_with_pieces({ 'd7' => 'p' })
        move = create_move(from_square: 'd7', to_square: 'd5', piece: 'p')
        described_class.execute_move(board, move)
        expect(board.en_passant_target).to eq(position('d6'))
      end

      it 'resets en passant target to nil before setting new one' do
        board = create_board_with_pieces({ 'e2' => 'P' }, en_passant_target: position('a3'))
        move = create_move(from_square: 'e2', to_square: 'e4', piece: 'P')
        described_class.execute_move(board, move)
        expect(board.en_passant_target).to eq(position('e3'))
      end
    end

    context 'when moving pawns one square' do
      it 'resets en passant target to nil for single pawn move' do
        board = create_board_with_pieces({ 'e3' => 'P' }, en_passant_target: position('d6'))
        move = create_move(from_square: 'e3', to_square: 'e4', piece: 'P')
        described_class.execute_move(board, move)
        expect(board.en_passant_target).to be_nil
      end

      it 'resets en passant target to nil for black pawn single move' do
        board = create_board_with_pieces({ 'd6' => 'p' }, en_passant_target: position('e3'))
        move = create_move(from_square: 'd6', to_square: 'd5', piece: 'p')

        described_class.execute_move(board, move)

        expect(board.en_passant_target).to be_nil
      end
    end

    context 'when moving non-pawn pieces' do
      it 'resets en passant target to nil for knight move' do
        board = create_board_with_pieces({ 'b1' => 'N' }, en_passant_target: position('e3'))
        move = create_move(from_square: 'b1', to_square: 'c3', piece: 'N')

        described_class.execute_move(board, move)

        expect(board.en_passant_target).to be_nil
      end

      it 'resets en passant target to nil for bishop move' do
        board = create_board_with_pieces({ 'c1' => 'B' }, en_passant_target: position('d6'))
        move = create_move(from_square: 'c1', to_square: 'e3', piece: 'B')

        described_class.execute_move(board, move)

        expect(board.en_passant_target).to be_nil
      end

      it 'resets en passant target to nil for rook move' do
        board = create_board_with_pieces({ 'a1' => 'R' }, en_passant_target: position('h6'))
        move = create_move(from_square: 'a1', to_square: 'a4', piece: 'R')

        described_class.execute_move(board, move)

        expect(board.en_passant_target).to be_nil
      end

      it 'resets en passant target to nil for queen move' do
        board = create_board_with_pieces({ 'd1' => 'Q' }, en_passant_target: position('a3'))
        move = create_move(from_square: 'd1', to_square: 'd4', piece: 'Q')

        described_class.execute_move(board, move)

        expect(board.en_passant_target).to be_nil
      end

      it 'resets en passant target to nil for king move' do
        board = create_board_with_pieces({ 'e1' => 'K' }, en_passant_target: position('f6'))
        move = create_move(from_square: 'e1', to_square: 'e2', piece: 'K')

        described_class.execute_move(board, move)

        expect(board.en_passant_target).to be_nil
      end
    end

    context 'when moving pieces that affect castling rights' do
      it 'calls update_castling_rights when moving a king' do
        board = create_board_with_pieces({ 'e1' => 'K' })
        move = create_move(from_square: 'e1', to_square: 'e2', piece: 'K')

        # We expect Board's update_castling_rights to be called
        expect(board).to receive(:update_castling_rights).with(move)

        described_class.execute_move(board, move)
      end

      it 'calls update_castling_rights when moving a rook' do
        board = create_board_with_pieces({ 'a1' => 'R' })
        move = create_move(from_square: 'a1', to_square: 'a4', piece: 'R')

        expect(board).to receive(:update_castling_rights).with(move)

        described_class.execute_move(board, move)
      end

      it 'does not call update_castling_rights when moving a pawn' do
        board = create_board_with_pieces({ 'e2' => 'P' })
        move = create_move(from_square: 'e2', to_square: 'e4', piece: 'P')

        expect(board).not_to receive(:update_castling_rights)

        described_class.execute_move(board, move)
      end

      it 'does not call update_castling_rights when moving a knight' do
        board = create_board_with_pieces({ 'b1' => 'N' })
        move = create_move(from_square: 'b1', to_square: 'c3', piece: 'N')

        expect(board).not_to receive(:update_castling_rights)

        described_class.execute_move(board, move)
      end
    end

    context 'edge cases' do
      it 'handles moves where piece positions are at board edges' do
        board = create_board_with_pieces({ 'a1' => 'R' })
        move = create_move(from_square: 'a1', to_square: 'h1', piece: 'R')

        described_class.execute_move(board, move)

        expect(board.piece_at(position('a1'))).to be_nil
        expect(board.piece_at(position('h1'))).to eq('R')
      end

      it 'handles moves to the same file' do
        board = create_board_with_pieces({ 'e2' => 'P' })
        move = create_move(from_square: 'e2', to_square: 'e3', piece: 'P')

        described_class.execute_move(board, move)

        expect(board.piece_at(position('e2'))).to be_nil
        expect(board.piece_at(position('e3'))).to eq('P')
      end
    end
  end
end
