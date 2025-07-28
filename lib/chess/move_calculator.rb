# frozen_string_literal: true

module Chess
  # Move Calculator generates the
  # possible moves each piece can
  # make.
  #
  # It does NOT validate
  # the moves. Validation happens
  # in Move Validator with the help
  # of specialty validation modules.
  #
  # It does NOT make the moves.
  class MoveCalculator
    include Directions
    attr_reader :position, :piece

    def self.generate_possible_moves(...)
      new(...).generate_possible_moves
    end

    def initialize(position, piece)
      @position = position
      @piece = piece
    end

    def generate_possible_moves
      # move direction of pawn depends on color
      return pawn_moves if %w[p P].include?(piece)
      return [] if piece.nil?

      case piece.downcase
      when 'k'
        king_moves
      when 'q'
        queen_moves
      when 'b'
        bishop_moves
      when 'n'
        knight_moves
      when 'r'
        rook_moves
      else
        []
      end.compact
    end

    def calculate_moves(directional_vectors, max_distance = 7)
      moves = []
      directional_vectors.each do |vector|
        (1..max_distance).each do |distance|
          row_delta = vector.first * distance
          column_delta = vector.last * distance
          delta_position = Position.from_coordinates(row_delta, column_delta)
          moves << (position + delta_position)
        end
      end
      moves
    end

    private

    def knight_moves
      KNIGHT.map do |vector|
        position + Position.from_directional_vector(vector)
      end.compact
    end

    def rook_moves
      calculate_moves(Directions::ROOK)
    end

    def bishop_moves
      calculate_moves(Directions::BISHOP)
    end

    def queen_moves
      vectors = Directions::ROOK + Directions::BISHOP
      calculate_moves(vectors)
    end

    def king_moves
      vectors = Directions::ROOK + Directions::BISHOP
      calculate_moves(vectors, 1)
    end

    def pawn_moves
      vectors = piece == 'p' ? Directions::PAWN_BLACK : Directions::PAWN_WHITE
      calculate_moves(vectors, 1)
    end
  end
end
