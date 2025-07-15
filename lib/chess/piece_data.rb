# frozen_string_literal: true

module Chess
  # Piece Data provides the different
  # chess pieces's data and
  # initial positions.
  module Piece
    ALLOWED_COLORS = %i[white black].freeze
    PIECE_SYMBOLS = {
      'K' => '♔', 'k' => '♚',
      'Q' => '♕', 'q' => '♛',
      'R' => '♖', 'r' => '♜',
      'B' => '♗', 'b' => '♝',
      'N' => '♘', 'n' => '♞',
      'P' => '♙', 'p' => '♟'
    }.freeze
    INITIAL_POSITIONS = {
      [0, 0] => 'r',
      [0, 1] => 'n',
      [0, 2] => 'b',
      [0, 3] => 'q',
      [0, 4] => 'k',
      [0, 5] => 'b',
      [0, 6] => 'n',
      [0, 7] => 'r',
      [1, 0] => 'p',
      [1, 1] => 'p',
      [1, 2] => 'p',
      [1, 3] => 'p',
      [1, 4] => 'p',
      [1, 5] => 'p',
      [1, 6] => 'p',
      [1, 7] => 'p',
      [6, 0] => 'P',
      [6, 1] => 'P',
      [6, 2] => 'P',
      [6, 3] => 'P',
      [6, 4] => 'P',
      [6, 5] => 'P',
      [6, 6] => 'P',
      [6, 7] => 'P',
      [7, 0] => 'R',
      [7, 1] => 'N',
      [7, 2] => 'B',
      [7, 3] => 'Q',
      [7, 4] => 'K',
      [7, 5] => 'B',
      [7, 6] => 'N',
      [7, 7] => 'R'
    }.freeze
  end
end
