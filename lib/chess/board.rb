# frozen_string_literal: true

require_relative 'config'

module Chess
  # Board represents a chess board.
  #
  # It contains the game board
  # and manages the rules of
  # the game.
  #
  # @example Create a new Board
  # board = Board.new
  #
  class Board
    attr_accessor :grid

    def initialize(grid)
      @grid = grid
    end

    def self.default(add_pieces: true)
      default_grid = Array.new(Chess::Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
      setup_pieces(default_grid) if add_pieces
      new(default_grid)
    end

    def self.setup_pieces(grid)
      Chess::Config::INITIAL_POSITIONS.each do |(rank, file), piece|
        grid[rank][file] = piece
      end
      grid
    end

    def extract_grid_and_pieces
      grid.map do |rank|
        rank.map do |file|
          if file.nil?
            ''
          else
            file.to_s
          end
        end
      end
    end
  end
end
