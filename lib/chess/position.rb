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
    include ChessNotation
    extend ChessNotation
    attr_reader :row, :column

    def self.from_coordinates(row_index, column_index)
      new(row_index, column_index)
    end

    # a2, d1, f8, g7, etc.
    def self.from_algebraic(algebraic_notation)
      rank, file = split_square_to_rank_file(algebraic_notation)
      row = rank_to_row(rank)
      column = file_to_col(file)
      new(row, column)
    end

    def self.from_directional_vector(array)
      row = array.first
      column = array.last
      new(row, column)
    end

    def initialize(row, column)
      @row = row
      @column = column
    end

    def rank
      return nil unless in_bound?

      row_to_rank(row)
    end

    def file
      return nil unless in_bound?

      col_to_file(column)
    end

    def square
      return nil unless in_bound?

      "#{col_to_file(column)}#{row_to_rank(row)}"
    end

    def coordinates
      return nil unless in_bound?

      [row, column]
    end

    def ==(other)
      row == other.row && column == other.column
    end

    def in_bound?
      return true if row.between?(0, Config::GRID_LENGTH - 1) &&
                     column.between?(0, Config::GRID_LENGTH - 1)

      false
    end

    # Parameter takes in a new position object with delta coordinates
    def transform_coordinates(position_delta)
      new_position = Position.new(
        position_delta.row + row, position_delta.column + column
      )
      new_position if new_position.in_bound?
    end

    def +(other)
      transform_coordinates(other)
    end

    def -(other)
      Position.new(row - other.row, column - other.column)
    end
  end
end
