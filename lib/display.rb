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
  module Display
    
    def self.map_pieces_symbols(piece)
      case piece
      when 'BR'
        '♜'
      when 'b'
        '🔵'
      when 'y'
        '🟡'
      else
        '🟣'
      end
    end
  end
end
