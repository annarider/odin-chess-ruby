# frozen_string_literal: true

module Chess
  # Directions Data saves the data
  # for the directional vectors for
  # easier move calculation. This
  # avoids having to remember the
  # delta numbers, especially which
  # direction is negative.
  #
  # It also stores the piece
  # movement vectors
  module Directions
    PAWN_WHITE = [
      [-1, 0],  # white forward
      [-2, 0],  # 2 forward
      [-1, -1], # diagonal_forward_left
      [-1, 1]   # diagonal_forward_right
    ].freeze
    PAWN_BLACK = [
      [1, 0],   # black forward
      [2, 0],   # 2 forward
      [1, 1],   # diagonal_forward_left
      [1, -1]   # diagonal_forward_right
    ].freeze
    KNIGHT = [
      [-1, 2], [1, 2], [2, 1], [2, -1],
      [1, -2], [-1, -2], [-2, -1], [-2, 1]
    ].freeze
    ROOK = [[-1, 0], [1, 0], [0, 1], [0, -1]].freeze
    BISHOP = [[1, 1], [1, -1], [-1, 1], [-1, -1]].freeze
    KING_CASTLING = [[0, 2], [0, -2]].freeze
  end
end
