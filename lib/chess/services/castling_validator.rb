# frozen_string_literal: true

module Chess
  # Check rules for castling rights.
  # This class contains methods to
  # ensure castling moves are allowed.
  module Castling
    def self.castling_legal?(...)
      new(...).can_castle?
    end

    def initialize(move, move_history = [])
      @king_start = move.from_position
      @king_end = move.to_position
      @piece = move.piece
      @rook_position = move.castling
      @move_history = move_history
    end

    def can_castle?
      return false if king_has_moved?
      return false if rook_has_moved?
      return false if king_in_check?(board, move)
      return false if path_in_check?(board, move)
      return false if castling_into_check?(board, move)

      true
    end

    private

    def king_has_moved?
      move_history.has_moved?(king_start)
    end

    def rook
      move_history.has_moved?
    end
  end
end
