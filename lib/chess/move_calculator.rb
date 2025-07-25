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
  module MoveCalculator
    include Directions
    def generate_possible_moves(position, piece)
      # move direction of pawn depends on color
      return pawn_moves(position, piece) if %w[p P].include?(piece)

      case piece.downcase
      when 'k'
        king_moves(position)
      when 'q'
        queen_moves(position)
      when 'b'
        bishop_moves(position)
      when 'n'
        knight_moves(position)
      when 'r'
        rook_moves(position)
      else
        []
      end.compact
    end

    def calculate_moves(position, directional_vectors, max_distance = 7)
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

    def knight_moves(position)
      KNIGHT.map do |vector|
        position + Position.from_directional_vector(vector)
      end.compact
    end

    def rook_moves(position)
      calculate_moves(position, Directions::ROOK)
    end

    def bishop_moves(position)
      calculate_moves(position, Directions::BISHOP)
    end

    def queen_moves(position)
      vectors = Directions::ROOK + Directions::BISHOP
      calculate_moves(position, vectors)
    end

    def king_moves(position)
      vectors = Directions::ROOK + Directions::BISHOP
      calculate_moves(position, vectors, 1)
    end

    def pawn_moves(position, piece)
      vectors = piece == 'p' ? Directions::PAWN_BLACK : Directions::PAWN_WHITE
      calculate_moves(position, vectors, 1)
    end
  end
end
