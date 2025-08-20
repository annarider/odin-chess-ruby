# frozen_string_literal: true

module Chess
  # Check rules for castling rights.
  # This class contains methods to
  # ensure castling moves are allowed.
  class CastlingValidator
    attr_reader :king_start, :king_end, :piece, :rook_position,
                :board, :move_history

    def self.castling_legal?(...)
      new(...).can_castle?
    end

    def initialize(move, board, move_history = [])
      @king_start = move.from_position
      @king_end = move.to_position
      @piece = move.piece
      @rook_position = move.castling
      @board = board
      @move_history = move_history
    end

    def can_castle?
      return false if king_has_moved?
      return false if rook_has_moved?
      return false if king_in_check?
      return false if path_in_check?
      return false if castling_into_check?

      true
    end

    private

    def king_has_moved?
      move_history.has_moved?(king_start)
    end

    def rook_has_moved?
      move_history.has_moved?(rook_position)
    end

    def king_in_check?
      CheckDetector.in_check?(board, calculate_color)
    end

    def path_in_check?
      path = PathCalculator.calculate_path_between(
        start: king_start,
        destination: king_end
      )
      path.any? { |square| CheckDetector.in_check?(board, calculate_color, square) }
    end

    def castling_into_check?
      CheckDetector.in_check?(board, calculate_color, king_end)
    end

    def calculate_color
      return nil unless piece

      piece.match?(/[A-Z]/) ? Chess::ChessNotation::WHITE_PLAYER : Chess::ChessNotation::BLACK_PLAYER
    end
  end
end
