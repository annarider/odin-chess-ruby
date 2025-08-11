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
    attr_reader :start_position, :end_position, :piece, :captured_piece,
      :move_history

    def self.valid_move?(...)
      new(...).valid_move?
    end

    def initialize(move, move_history = [])
      @start_position = move.from_position
      @end_position = move.to_position
      @piece = move.piece
      @captured_piece = move.captured_piece
      @move_history = move_history
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
      # Pawns move diagonally only for capturing
      return false unless captured_piece

      # must only capture enemy pieces
      PieceHelpers.enemy_color?(piece, captured_piece)
    end

    def forward_move_valid?
      # If pawn tries to move 2 squares, it must not have moved before
      return false if start_position.two_rank_move?(end_position) && pawn_has_moved?

      # Pawn can move 1 square forward. Move directions limited in MoveCalculator
      # Destination is empty is checked in MoveValidator
      true
    end

    def pawn_has_moved?
      move_history.has_moved?(start_position)
    end
  end
end
