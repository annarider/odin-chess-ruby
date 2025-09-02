# frozen_string_literal: true

module Chess
  # MoveCommander is responsible for executing moves
  # and coordinating all board state updates.
  # It orchestrates the sequence of operations
  # needed when a move is played, telling the
  # board what updates to perform.
  class MoveCommander
    attr_reader :board, :move, :piece, :from_position, :to_position

    def self.execute_move(...)
      new(...).execute_move
    end

    def initialize(board, move)
      @board = board
      @move = move
      @piece = move.piece
      @from_position = move.from_position
      @to_position = move.to_position
    end

    def execute_move
      update_piece_positions
      update_castling_rights if affects_castling?
      update_en_passant_target
    end

    private

    def update_piece_positions
      board.update_position(from_position, to_position)
    end

    def update_castling_rights
      board.update_castling_rights(move)
    end

    def update_en_passant_target
      board.update_en_passant_target(move)
    end

    def affects_castling?
      Piece::KING_PIECES.include?(piece) || Piece::ROOK_PIECES.include?(piece)
    end
  end
end
