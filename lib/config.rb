# frozen_string_literal: true

# Configuration stores game settings.
module Config
  GRID_LENGTH = 8
  INITIAL_POSITIONS = {
    [0, 0] => 'DR',
    [0, 1] => 'DN',
    [0, 2] => 'DB',
    [0, 3] => 'DQ',
    [0, 4] => 'DK',
    [0, 5] => 'DB',
    [0, 6] => 'DN',
    [0, 7] => 'DK',
    [1, 0] => 'DP',
    [1, 1] => 'DP',
    [1, 2] => 'DP',
    [1, 3] => 'DP',
    [1, 4] => 'DP',
    [1, 5] => 'DP',
    [1, 6] => 'DP',
    [1, 7] => 'DP',
    [6, 0] => 'LP',
    [6, 1] => 'LP',
    [6, 2] => 'LP',
    [6, 3] => 'LP',
    [6, 4] => 'LP',
    [6, 5] => 'LP',
    [6, 6] => 'LP',
    [6, 7] => 'LP',
    [7, 0] => 'LR',
    [7, 1] => 'LN',
    [7, 2] => 'LB',
    [7, 3] => 'LQ',
    [7, 4] => 'LK',
    [7, 5] => 'LB',
    [7, 6] => 'LN',
    [7, 7] => 'LR'
  }
  BLACK_SQUARE_COLOR = 'blue'
  WHITE_SQUARE_COLOR = 'white'
end
