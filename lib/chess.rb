# frozen_string_literal: true

require_relative 'chess/data/config'
require_relative 'chess/data/directions'
require_relative 'chess/data/piece'

require_relative 'chess/helpers/chess_notation'
require_relative 'chess/helpers/colorize_string'
require_relative 'chess/helpers/display'
require_relative 'chess/helpers/from_fen'
require_relative 'chess/helpers/interface'
require_relative 'chess/helpers/move_patterns'
require_relative 'chess/helpers/piece_helpers'
require_relative 'chess/helpers/to_fen'

require_relative 'chess/services/attack_calculator'
require_relative 'chess/services/castling_validator'
require_relative 'chess/services/check_detector'
require_relative 'chess/services/checkmate_detector'
require_relative 'chess/services/en_passant_validator'
require_relative 'chess/services/move_calculator'
require_relative 'chess/services/move_validator'
require_relative 'chess/services/path_calculator'
require_relative 'chess/services/pawn_move_validator'
require_relative 'chess/services/promotion_validator'

require_relative 'chess/core/board'
require_relative 'chess/core/game'
require_relative 'chess/core/move_history'
require_relative 'chess/core/move'
require_relative 'chess/core/position'

# top-level namespace for organization
# and contain the library files for
# easy loading
module Chess
end
