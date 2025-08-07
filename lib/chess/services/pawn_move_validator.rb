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
    def self.valid_move?(...)
      new(...).valid_move?
    end

    def initialize(move, move_history = [])
      @from_position = move.from_position
      @to_position = move.to_position
      @move_history = move_history
    end

    def valid_move?
      if from_position.diagonal_move?(to_position)
        diagonal_move_valid?
      else
        forward_move_valid?
      end
    end
  end
end
