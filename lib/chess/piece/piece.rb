# frozen_string_literal: true

module Chess
  # Custom Error class to handle when a
  # Position object is out of bounds
  # Cite: https://stackoverflow.com/a/5369746
  class OutOfBoundsError < StandardError
    attr_reader :position

    def initialize(position, message = nil)
      @position = position
      message ||= "Position #{position} is off the board"
      super(message)
    end
  end

  # Piece is a super class which
  # defines behavior for pieces in Chess.
  #
  # It manages manages general piece
  # functionality in the game. Subclasses,
  # such as rook and pawn, will inherit
  # methods from this Piece superclass.
  class Piece
    attr_accessor :moved, :position
    attr_reader :color

    def initialize(position, color: :white, moved: false)
      @position = position
      @color = validate_and_set_color(color)
      @moved = moved
    end

    def moved?
      moved
    end

    def mark_as_moved!
      @moved = true
    end

    def move(direction)
      coordinates = unpack_move_deltas(direction)
      new_position = create_new_position(coordinates)
      raise_out_of_bounds_error(new_position) if new_position.nil?
      legal_move = legal_move?(direction)
      @position = new_position if legal_move
    end

    protected

    def legal_move?(direction); end

    private

    def validate_and_set_color(new_color)
      unless Chess::Config::ALLOWED_COLORS.include?(new_color)
        raise ArgumentError, "Invalid color: #{new_color}. Allowed colors: #{Config::ALLOWED_COLORS}"
      end

      @color = new_color
    end

    def unpack_move_deltas(direction)
      unless MOVE_DIRECTIONS.include?(direction)
        raise ArgumentError, "Invalid direction: #{direction}. Allowed are: #{MOVE_DIRECTIONS}"
      end

      MOVE_DIRECTIONS[direction].map do |delta|
        adjust_direction_using_color(delta)
      end
    end

    def adjust_direction_using_color(squares)
      color == :white ? (-1 * squares) : squares
    end

    def create_new_position(coordinates)
      row_delta = coordinates[0]
      column_delta = coordinates[1]
      position.transform_coordinates(Position.new(row_delta, column_delta))
    end

    def raise_out_of_bounds_error(position)
      raise Chess::OutOfBoundsError.new(position), "Position #{position} is off the board"
    end
  end
end
