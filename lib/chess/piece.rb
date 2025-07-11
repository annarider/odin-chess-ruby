# frozen_string_literal: true

module Chess
  # Piece is a super class which
  # defines behavior for pieces in Chess.
  #
  # It manages manages general piece
  # functionality in the game. Subclasses,
  # such as rook and pawn, will inherit
  # methods from this Piece superclass.
  class Piece
    attr_reader :color, :type

    def initialize(type, color = :white)
      @type = type
      @color = color
    end
  end
end
