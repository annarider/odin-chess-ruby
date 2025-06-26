# frozen_string_literal: true

# Piece is a super class which
# defines behavior for pieces in Chess.
#
# It manages manages general piece
# functionality in the game. Subclasses,
# such as rook and pawn, will inherit
# methods from this Piece super class.
#
#
module Chess
  class Piece
    attr_accessor :moved

    def initialize(moved: false)
      @moved = moved
    end

    def moved?
      moved
    end

    def mark_as_moved!
      @moved = true
    end

  end
end
