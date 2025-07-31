# frozen_string_literal: true

require_relative '../../lib/chess'

module Chess
  # Board Builder contains the methods
  # to create the grid and optionally
  # set up the starting pieces for a
  # Chess game.
    class BoardBuilder
      def self.initial_start(add_pieces: true)
        setup_starting_grid = add_pieces ? setup_pieces(empty_grid) : empty_grid
        new(grid: setup_starting_grid)
      end

      def self.from_fen(fen_string)
        parsed_data = parse_fen(fen_string)
        new(**parsed_data)
      end

      def self.empty_grid
        Array.new(Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
      end

      def initialize
        @
      end

      private

      def setup_pieces(grid)
        Piece::INITIAL_POSITIONS.each do |(rank, file), piece|
          grid[rank][file] = piece
        end
        grid
      end
    end
  end
