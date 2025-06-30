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
    attr :row, :column
    
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

    def up(row_number, column_number)
      # return a position one rank "up" from the perspective
      # of this method's receiver
      
    end
  end
end
