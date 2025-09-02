# frozen_string_literal: true

module Chess
  # Stalemate Validator checks whether
  # stalemate conditions are achieved.
  # This class relies on CheckDetector
  # to determine if the king is NOT in check.
  #
  # Then it decides if there are any
  # legal moves for the active player.
  class StalemateValidator
    include GameAnalysis
    include Piece
    attr_reader :board, :active_color, :king_position

    def self.stalemate?(...)
      new(...).stalemate?
    end

    def initialize(board, active_color, king_position = nil)
      @board = board
      @active_color = active_color
      @king_position = king_position || locate_king
    end

    def stalemate?
      return false if CheckDetector.in_check?(board, active_color, king_position)

      no_legal_moves?
    end

    private

    def no_legal_moves?
      moves = find_friendly_moves
      return true if moves.empty?

      moves.none? { |move| move_leaves_king_safe?(move) }
    end
  end
end
