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
    FIRST_RANK = 7
    SECOND_RANK = 6
    SEVENTH_RANK = 1
    FIRST_FILE = 0
    LAST_FILE = 7
  
    attr_accessor :grid

    def initialize
      @grid = Array.new(Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
    end

    def set_up_pieces
      Config::INITIAL_POSITIONS.each do |(rank, file), piece|
        @grid[rank][file] = piece
      end
    end
  end
end
