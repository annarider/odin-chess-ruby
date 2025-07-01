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

    def initialize(position, color: :white, moved: false)
      @position = position
      validate_and_set_color(color)
      @moved = false
    end

    def move
      offset_delta = calculate_color_offset
      new_coordinates = calculate_new_coordinates(offset_delta)
      new_position = create_new_position(new_coordinates)
      unless new_position.in_bound?
        raise ArgumentError "Out-of-bounds: position #{new_position} is off game board"
      end
      
      @position = new_position
    end

    private

    def calculate_color_offset
      color == :white ? -1 : 1
    end

    def calculate_new_coordinates(offset_delta)
      position.transform_coordinates(offset_delta, 0)
    end

    def create_new_position(coordinates)
      row = coordinates[0]
      column = coordinates[1]
      Position.new(row, column)
    end
  end
end
