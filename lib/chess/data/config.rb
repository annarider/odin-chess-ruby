# frozen_string_literal: true

# Configuration stores game settings.
module Chess
  module Config
    GRID_LENGTH = 8
    RGB_COLOR_MAP = {
      white: '232;235;239',
      black: '35;65;75'
    }.freeze
    EMPTY_SQUARE_PADDING = '   '
    PIECE_PADDING = ' '
  end
end
