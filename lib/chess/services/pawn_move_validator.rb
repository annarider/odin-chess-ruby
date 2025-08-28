# frozen_string_literal: true

module Chess
  # PawnMoveValidator handles pawn-specific
  # move validation rules that go beyond
  # the basic move generation.
  #
  # It validates:
  # - Diagonal moves only for captures
  # - Two-square moves only for unmoved pawns
  # - Forward moves only to empty squares
  class PawnMoveValidator
    attr_reader :board, :start_position, :end_position, :piece,
                :captured_piece

    def self.valid_move?(...)
      new(...).valid_move?
    end

    def initialize(board, move)
      @board = board
      @start_position = move.from_position
      @end_position = move.to_position
      @piece = move.piece
      @captured_piece = board.piece_at(move.to_position)
    end

    def valid_move?
      if start_position.diagonal_move?(end_position)
        capture_move_valid? # pawn can't move to an empty square
      else
        forward_move_valid?
      end
    end

    private

    def capture_move_valid?
      # Pawns move diagonally only for capturing opponent pieces
      return false unless captured_piece &&
      # Pawn must only capture enemy pieces
        PieceHelpers.opponent_color?(attack_piece: piece, captured_piece: captured_piece)

      true
    end

    def forward_move_valid?
      # Advance forward is valid if not capturing a piece
      return false unless board.piece_at(end_position).nil?
      # If pawn tries to move 2 squares, it must not have moved before
      return false if start_position.two_rank_move?(end_position) && pawn_has_moved?

      # Pawn can move 1 square forward. Move directions limited in MoveCalculator
      # Destination is empty is checked in MoveValidator
      # Path clearing for 2-square moves is handled by MoveValidator#clear_path?
      true
    end

    def pawn_has_moved?
      # white pawns start on rank 2; black pawns start on rank 7
      starting_rank = piece == 'P' ? '2' : '7'
      start_position.rank != starting_rank
    end
  end
end
