# frozen_string_literal: true

module Chess
  # MovePatterns provides shared logic for piece movement calculations
  # Used by both MoveCalculator and AttackCalculator to eliminate duplication
  module MovePatterns
    def self.linear_moves(position, directions, board: nil, max_distance: 7)
      moves = []
      directions.each do |dr, dc|
        delta = Position.from_directional_vector([dr, dc])
        current_pos = position

        distance = 0
        loop do
          distance += 1
          break if distance > max_distance

          current_pos += delta
          break unless current_pos # Out of bounds

          moves << current_pos

          # If board provided, stop at pieces (for attacks)
          # If no board, continue to max_distance (for moves)
          break if board&.piece_at(current_pos)
        end
      end
      moves
    end

    def self.single_moves(position, directions)
      directions.filter_map do |dr, dc|
        delta = Position.from_directional_vector([dr, dc])
        position + delta
      end.compact
    end

    def self.pawn_diagonals(position, piece)
      directions = white_piece?(piece) ? Directions::PAWN_WHITE : Directions::PAWN_BLACK
      diagonal_directions = directions.last(2) # Last 2 are diagonals
      single_moves(position, diagonal_directions)
    end

    def self.white_piece?(piece)
      piece == piece.upcase
    end
  end
end
