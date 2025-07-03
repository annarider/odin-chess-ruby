# frozen_string_literal: true

require_relative '../../chess'

module Chess
  # Pawn defines behavior for
  # a pawn piece in Chess.
  #
  # It inherits from the Piece
  # superclass. It also defines
  # pawn-specific functionality
  # such as moves, in the game.
  #
  # @example Create a new Pawn
  # pawn1 = Pawn.new
  class Pawn < Piece
    attr_accessor :position

    PAWN_MOVE_SQUARES = {
      forward_one: [1, 0],
      forward_two: [2, 0],
      diagonal_left: [1, 1],
      diagonal_right: [1, -1]
    }

    def initialize(position, color: :white, moved: false)
      @position = position
      validate_and_set_color(color)
      @moved = false
    end

    def move(direction)
      adjusted_row_delta, adjusted_column_delta = unpack_move_deltas(direction)
      new_coordinates = calculate_new_coordinates(adjusted_row_delta, adjusted_column_delta)
      p new_coordinates
      raise ArgumentError, "Out-of-bounds: position #{new_coordinates} is off game board" if new_coordinates.nil?

      new_position = create_new_position(new_coordinates) if new_coordinates
      @position = new_position
    end

    private

    def unpack_move_deltas(direction)
      PAWN_MOVE_SQUARES[direction].map do |delta|
        adjust_direction_using_color(delta)
      end
    end

    def adjust_direction_using_color(squares)
      color == :white ? (-1 * squares) : squares
    end

    def calculate_new_coordinates(row_delta, column_delta)
      position.transform_coordinates(row_delta, column_delta)
    end

    def create_new_position(coordinates)
      row = coordinates[0]
      column = coordinates[1]
      Position.new(row, column)
    end
  end
end
