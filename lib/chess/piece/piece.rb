# frozen_string_literal: true

module Chess
  # Piece is a super class which
  # defines behavior for pieces in Chess.
  #
  # It manages manages general piece
  # functionality in the game. Subclasses,
  # such as rook and pawn, will inherit
  # methods from this Piece superclass.
  #
  class Piece
    attr_accessor :moved
    attr_reader :color

    def initialize(color, moved: false)
      validate_and_set_color(color)
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
  end
end
