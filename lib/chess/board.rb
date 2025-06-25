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

    def initialize(add_pieces: true)
      @grid = Array.new(Chess::Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
      set_up_pieces if add_pieces
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

    private

    def set_up_pieces
      Chess::Config::INITIAL_POSITIONS.each do |(rank, file), piece|
        @grid[rank][file] = piece
      end
    end
  end
end
