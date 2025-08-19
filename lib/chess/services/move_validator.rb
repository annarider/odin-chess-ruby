# frozen_string_literal: true

module Chess
  # Move Validator performs checks
  # to ensure the move is valid
  # before allow the move to
  # persist and update the board/
  # game state.
  #
  # Move Validator may call upon
  # helper classes to perform
  # specialty validations, such as
  # check.
  class MoveValidator
    attr_reader :board, :move, :start_position, :end_position, :piece,
                :move_history

    def self.move_legal?(...)
      new(...).move_legal?
    end

    # def self.two_square_pawn_move?()
    def initialize(board, move, move_history = [])
      @board = board
      @move = move
      @start_position = move.from_position
      @end_position = move.to_position
      @piece = move.piece
      @move_history = move_history
    end

    def move_legal?
      return false unless possible_move?
      return false unless valid_destination?
      return false unless clear_path?
      return false unless valid_piece_moves?

      true
    end

    private

    def possible_move?
      all_moves = MoveCalculator.generate_possible_moves(start_position, piece)
      all_moves.include?(end_position)
    end

    def valid_destination?
      target_piece = board.piece_at(end_position)

      if target_piece.nil? # empty square
        true
      else
        PieceHelpers.opponent_color?(attack_piece: piece, captured_piece: target_piece)
      end
    end

    def clear_path?
      return true if %w[n N].include?(piece)

      path = PathCalculator.calculate_path_between(
        board,
        start: start_position,
        destination: end_position
        )
      empty_square_along_path?(path)
    end

    # are there any pieces along the piece's movement path?
    def empty_square_along_path?(path)
      route = path[0...-1] # remove destination square
      return true if route.all? { |position| board.piece_at(position).nil? }

      false
    end

    def valid_piece_moves?
      return PawnMoveValidator.valid_move?(move, move_history) if %w[P p].include?(piece)

      # other pieces return true as they don't have piece-specific moves
      true
    end
  end
end
