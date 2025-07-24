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
    include MoveCalculator
    def is_move_legal?(board, move)
      return false unless possible_move?(board, move)
      return false unless valid_destination?(board, move)
      return false unless clear_path?(board, move)

      true
    end

    private

    def possible_move?(board, move)
      all_moves = board.possible_moves(move.from_position)
      all_moves.include?(move.to_position)
    end

    def valid_destination?(board, move)
      target_piece = board.piece_at(move.to_position)

      if target_piece.nil? # empty square
        true
      else
        enemy_color?(move.piece, target_piece)
      end
    end

    def enemy_color?(attack_piece, captured_piece)
      (attack_piece.match?(/[A-Z]/) && captured_piece.match?(/[a-z]/)) ||
        (attack_piece.match?(/[a-z]/) && captured_piece.match?(/[A-Z]/))
    end

    def clear_path?(board, move)
      return true if %w[n N].include?(move.piece)

      path = calculate_path_between(move.from_position, move.to_position)
      empty_square_along_path?(board, path)
    end

    def calculate_path_between(start_position, end_position)
      total_row_delta = end_position.row - start_position.row
      total_column_delta = end_position.column - start_position.column
      direction_vector = [convert_direction(total_row_delta), convert_direction(total_column_delta)]
      steps = [total_row_delta.abs, total_column_delta.abs].max
      calculate_moves(start_position, [direction_vector], steps)
    end

    def empty_square_along_path?(board, path)
      route = path[0...-1] # remove destination square
      return true if route.all? { |vector| board.piece_at(vector).nil? }

      false
    end

    def convert_direction(delta)
      return 0 if delta.zero?

      delta.positive? ? 1 : -1
    end
  end
end
