# frozen_string_literal: true

require_relative 'chess/config'
require_relative 'chess/colorize_string'
require_relative 'chess/chess_notation'
require_relative 'chess/from_fen'
require_relative 'chess/to_fen'
require_relative 'chess/display'
require_relative 'chess/directions_data'
require_relative 'chess/piece_data'
require_relative 'chess/board'
require_relative 'chess/position'
require_relative 'chess/game_state'

# top-level namespace for organization
# and contain the library files for
# easy loading
module Chess
end
