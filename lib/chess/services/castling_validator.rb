# frozen_string_literal: true

module Chess
  # Check rules for castling rights.
  # This class contains methods to
  # ensure castling moves are allowed.
  class CastlingValidator
    attr_reader :board, :king_start, :king_end, :piece, :rook_position,
                :move_history

    def self.castling_legal?(...)
      new(...).legal?
    end

    def initialize(board, move, move_history = MoveHistory.new)
      @board = board
      @king_start = move.from_position
      @king_end = move.to_position
      @piece = move.piece
      @rook_position = move.castling
      @move_history = move_history
    end

    def legal?
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
      CheckDetector.in_check?(board, PieceHelpers.calculate_color(piece))
    end

    def path_in_check?
      path = PathCalculator.calculate_path_between(
        start: king_start,
        destination: king_end
      )
      path.any? do |square|
        CheckDetector.in_check?(
          board,
          PieceHelpers.calculate_color(piece),
          square
        )
      end
    end

    def castling_into_check?
      CheckDetector.in_check?(
        board,
        PieceHelpers.calculate_color(piece),
        king_end
      )
    end
  end
end
