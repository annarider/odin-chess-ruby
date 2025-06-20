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
