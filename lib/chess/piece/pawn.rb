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
    # Custom error class for
    # handling invalid pawn moves
    class InvalidMove < StandardError
      def initialize(message = nil)
        message ||= 'Invalid move for pawn.'
        super
      end
    end

    MOVE_DIRECTIONS = {
      forward_one: [1, 0],
      forward_two: [2, 0],
      diagonal_left: [1, 1],
      diagonal_right: [1, -1]
    }.freeze

    def initialize(position, color: :white, moved: false)
      super
    end

    protected

    def legal_move?(direction)
      block_forward_two(direction)
    end

    private

    def block_forward_two(direction)
      return unless direction == :forward_two && moved == true

      raise InvalidMove, 'Pawn has already moved and can only advance 1 square'
    end
  end
end
