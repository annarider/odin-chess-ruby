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

    def initialize(add_pieces: true)
      @grid = Array.new(Chess::Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
      set_up_pieces if add_pieces
    end

    private

    def set_up_pieces
      Chess::Config::INITIAL_POSITIONS.each do |(rank, file), piece|
        @grid[rank][file] = piece
      end
    end
  end
end
