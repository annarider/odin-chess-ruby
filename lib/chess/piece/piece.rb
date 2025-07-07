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

    private

    def validate_and_set_color(new_color)
      unless Chess::Config::ALLOWED_COLORS.include?(new_color)
        raise ArgumentError, "Invalid color: #{new_color}. Allowed colors: #{Config::ALLOWED_COLORS}"
      end

      @color = new_color
    end

    def raise_out_of_bounds_error(position)
      raise Chess::OutOfBoundsError.new(position)
    end

  end
end
