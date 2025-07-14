# frozen_string_literal: true

module Chess
  # Position defines a position on
  # the chess game board.
  #
  # It contains the data about a
  # position on the grid.
  #
  # @example Create a new Position
  # position = Position.new(row, column)
  #
  class Position
    include Chess::ChessNotation
    attr_reader :row, :column

    def self.from_numeric(row_number, column_number)
      new(row_number, column_number)
    end

    # a2, d1, f8, g7, etc.
    def self.from_rank_file(string)
      row, column = convert_rank_file_to_num(string)
      new(row, column)
    end

    def initialize(row_number, column_number)
      @row = row_number
      @column = column_number
    end

    def rank
      convert_num_to_rank(row)
    end

    def file
      convert_num_to_file(column)
    end

    def square
      convert_num_to_rank_file(row, column)
    end

    def +(other)
      # TODO
    end

    def ==(other)
      row == other.row && column == other.column
    end

    def in_bound?
      return false if row.negative? ||
                      row >= Chess::Config::GRID_LENGTH ||
                      column.negative? ||
                      column >= Chess::Config::GRID_LENGTH

      true
    end

    # Parameter takes in a new position object with delta coordinates
    def transform_coordinates(position_delta)
      new_position = Position.new(
        position_delta.row + row, position_delta.column + column
      )
      new_position if new_position.in_bound?
    end
  end
end
