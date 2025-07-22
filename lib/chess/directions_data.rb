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
    WHITE = {
      forward: [-1, 0],
      backward: [1, 0],
      left: [0, -1],
      right: [0, 1],
      diagonal_forward_left: [-1, -1],
      diagonal_forward_right: [-1, 1],
      diagonal_backward_left: [1, -1],
      diagonal_backward_right: [1, 1]
    }.freeze
    BLACK = {
      forward: [1, 0],
      backward: [-1, 0],
      left: [0, 1],
      right: [0, -1],
      diagonal_forward_left: [1, 1],
      diagonal_forward_right: [1, -1],
      diagonal_backward_left: [-1, 1],
      diagonal_backward_right: [-1, -1]
    }.freeze
    KNIGHT = [
      [-1, 2], [1, 2], [2, 1], [2, -1],
      [1, -2], [-1, -2], [-2, -1], [-2, 1]
    ].freeze
    ROOK = [[-1, 0], [1, 0], [0, 1], [0, -1]]
  end
end
