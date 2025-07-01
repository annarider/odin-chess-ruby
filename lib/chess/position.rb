# frozen_string_literal: true

# Position defines a position on
# the chess game board.
#
# It contains the data about a
# position on the grid.
#
# @example Create a new Position
# position = Position.new(row, column)
#
module Chess
  class Position
    attr_reader :row, :column

    def self.from_numeric(row_number, column_number)
      [row_number, column_number]
    end

    def self.from_rank_file(string)
      # TODO
    end

    def initialize(row_number, column_number)
      @row = row_number
      @column = column_number
    end

    def rank
      # TODO
    end

    def file
      # TODO
    end

    def rank_and_file
      # TODO
    end

    def +(other)
      # TODO
    end

    def ==(other)
      row == other.row && column == other.column
    end

    def in_bound?(row_number = row, column_number = column)
      return false if row_number.negative? ||
                      row_number > Chess::Config::GRID_LENGTH ||
                      column_number.negative? ||
                      column_number > Chess::Config::GRID_LENGTH

      true
    end

    def transform_coordinates(row_delta, column_delta)
      transformed_row = row + row_delta
      transformed_column = column + column_delta
      [transformed_row, transformed_column] if in_bound?(transformed_row, transformed_column)
    end
  end
end
