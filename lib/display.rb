# frozen_string_literal: true

# Display defines how to display
# the game board in Chess.
#
# It manages displaying the board,
# the pieces, and colors. It
# doesn't include the IO
# functionality in the game.
#
# @example Create a new Board
# board = Board.new
#
module Chess
  class Display
    attr_reader :board

    PIECE_SYMBOLS = {
        'WK' => '♔', 'BK' => '♚',
        'WQ' => '♕', 'BQ' => '♛',
        'WR' => '♖', 'BR' => '♜',
        'WB' => '♗', 'BB' => '♝',
        'WN' => '♘', 'BN' => '♞',
        'WP' => '♙', 'BP' => '♟'
      }

    def initialize(board)
      @board = board
    end
    
    def build_board_for_display
      
    end

    def map_piece_symbol(code)
      PIECE_SYMBOLS[code]
    end
  end
end
