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
    [2, 0] => 'DP',
    [3, 0] => 'DP',
    [4, 0] => 'DP',
    [5, 0] => 'DP',
    [6, 0] => 'DP',
    [7, 0] => 'DP',
    [6, 0] => 'LP',
  }
  DARK_SQUARE_COLOR = 'blue'
  LIGHT_SQUARE_COLOR = 'white'
end
