# frozen_string_literal: true

require_relative 'colored_string'

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
    using Chess::ColoredString
    attr_reader :board

    def initialize(board)
      @board = board
    end

    def map_piece_symbol(code)
      PIECE_SYMBOLS[code]
    end

    def format_checkered_grid
      grid = extract_grid_with_pieces
      grid.each_with_index do |rank, rank_index|
        rank.map.with_index do |file, file_index|
          combined_indices = rank_index + file_index
          print calculate_checkered_color(combined_indices, file)
        end
        print "\n"
      end
    end

    private

    def extract_grid_with_pieces
      board.grid.map do |rank|
        rank.map do |file|
          if file.nil?
            ' a '
          else
            ' ♟ '
          end
        end
      end
    end

    def calculate_checkered_color(index, file)
      if index.even? # "white on the right"
        file.output_color(:gray, ground: 'back')
      else
        file.output_color(:slate, ground: 'back')
      end
    end
  end
end
