module Chess
  # Check rules for castling rights.
  # This module contains methods to
  # ensure castling moves are allowed.
  module Castling
    def can_castle?(board, move)
      return false if king_moved?(board)
      return false if rook_moved?(board)
      return false if king_in_check?(board, move)
      return false if path_in_check?(board, move)
      return false if castling_into_check?(board, move)

      true
    end

    private

    def king_moved?(board, move)
      
    end
  end
end
