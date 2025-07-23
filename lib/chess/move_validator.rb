# frozen_string_literal: true

module Chess
  # Move Validator performs checks
  # to ensure the move is valid
  # before allow the move to
  # persist and update the board/
  # game state.
  #
  # Move Validator may call upon
  # helper modules to perform
  # specialty validations, such as
  # check.
  module MoveValidator
    def is_move_legal?(board, move)
      return false unless possible_move?(board, move)

      true
    end

    private

    def possible_move?(board, move)
      all_moves = board.possible_moves(move.from_position)
      all_moves.include?(move.to_position)
    end
  end
end
