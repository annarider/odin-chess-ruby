# frozen_string_literal: true

# Configuration stores game settings.
module Chess
  module Config
    GRID_LENGTH = 8
    PIECE_SYMBOLS = {
    'WK' => '♔', 'BK' => '♚',
    'WQ' => '♕', 'BQ' => '♛',
    'WR' => '♖', 'BR' => '♜',
    'WB' => '♗', 'BB' => '♝',
    'WN' => '♘', 'BN' => '♞',
    'WP' => '♙', 'BP' => '♟'
    }
    INITIAL_POSITIONS = {
      [0, 0] => 'BR',
      [0, 1] => 'BN',
      [0, 2] => 'BB',
      [0, 3] => 'BQ',
      [0, 4] => 'BK',
      [0, 5] => 'BB',
      [0, 6] => 'BN',
      [0, 7] => 'BK',
      [1, 0] => 'BP',
      [1, 1] => 'BP',
      [1, 2] => 'BP',
      [1, 3] => 'BP',
      [1, 4] => 'BP',
      [1, 5] => 'BP',
      [1, 6] => 'BP',
      [1, 7] => 'BP',
      [6, 0] => 'WP',
      [6, 1] => 'WP',
      [6, 2] => 'WP',
      [6, 3] => 'WP',
      [6, 4] => 'WP',
      [6, 5] => 'WP',
      [6, 6] => 'WP',
      [6, 7] => 'WP',
      [7, 0] => 'WR',
      [7, 1] => 'WN',
      [7, 2] => 'WB',
      [7, 3] => 'WQ',
      [7, 4] => 'WK',
      [7, 5] => 'WB',
      [7, 6] => 'WN',
      [7, 7] => 'WR'
    }
    RGB_COLOR_MAP = {
      gray: '232;235;239',
      slate: '35;65;75'
    }
  end
end
