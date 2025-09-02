# frozen_string_literal: true

module Chess
  # AttackCalculator generates squares that pieces threaten/attack
  # Used by CheckDetector to determine if king is in check
  # Does NOT consider board state for move legality - only attack patterns
  class AttackCalculator
    def self.generate_attack_squares(position, piece, board = nil)
      new(position, piece, board).generate_attack_squares
    end

    def initialize(position, piece, board = nil)
      @position = position
      @piece = piece
      @board = board
    end

    def generate_attack_squares
      return [] if piece.nil?

      case piece.downcase
      when 'p'
        pawn_attacks
      when 'r'
        rook_attacks
      when 'n'
        knight_attacks
      when 'b'
        bishop_attacks
      when 'q'
        queen_attacks
      when 'k'
        king_attacks
      else
        []
      end
    end

    private

    attr_reader :position, :piece, :board

    def pawn_attacks
      MovePatterns.pawn_diagonals(position, piece)
    end

    def rook_attacks
      MovePatterns.linear_moves(position, Directions::ROOK, board: board)
    end

    def bishop_attacks
      MovePatterns.linear_moves(position, Directions::BISHOP, board: board)
    end

    def queen_attacks
      MovePatterns.linear_moves(position, Directions::ROOK + Directions::BISHOP, board: board)
    end

    def knight_attacks
      MovePatterns.single_moves(position, Directions::KNIGHT)
    end

    def king_attacks
      king_directions = Directions::ROOK + Directions::BISHOP
      MovePatterns.single_moves(position, king_directions)
    end
  end
end
