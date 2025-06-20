# frozen_string_literal: true

require_relative 'config'

# Board represents a chess board.
#
# It contains the game board
# and manages the rules of
# the game.
#
# @example Create a new Board
# board = Board.new
#
module Chess
  class Board
    SECOND_RANK = 6
    SEVENTH_RANK = 1
  
    attr_accessor :grid

    def initialize
      @grid = Array.new(Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
    end

    def set_up_pieces
      grid[SECOND_RANK].map! { |file| file = 'DP' }
      grid[SEVENTH_RANK].map! { |file| file = 'LP' }
    end
  end
end
