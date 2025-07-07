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

    PAWN_MOVE_SQUARES = {
      forward_one: [1, 0],
      forward_two: [2, 0],
      diagonal_left: [1, 1],
      diagonal_right: [1, -1]
    }.freeze

    def initialize(position, color: :white, moved: false)
      super
    end

    def move(direction)
      block_forward_two(direction) if moved == true
      coordinates = unpack_move_deltas(direction)
      new_position = create_new_position(coordinates)
      raise_out_of_bounds_error(new_position) if new_position.nil?
      @position = new_position
    end

    private

    def block_forward_two(direction)
      return unless direction == :forward_two && moved == true

      raise InvalidMove, 'Pawn has already moved and can only advance 1 square'
    end

    def unpack_move_deltas(direction)
      unless PAWN_MOVE_SQUARES.include?(direction)
        raise ArgumentError, "Invalid direction: #{direction}. Allowed are: #{PAWN_MOVE_SQUARES}"
      end

      PAWN_MOVE_SQUARES[direction].map do |delta|
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
  end
end
