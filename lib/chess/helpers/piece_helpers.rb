# frozen_string_literal: true

module Chess
  module PieceHelpers
    # checks if the captured piece is an enemy color
    def self.opponent_color?(attack_piece:, captured_piece:)
      (attack_piece.match?(/[A-Z]/) && captured_piece.match?(/[a-z]/)) ||
        (attack_piece.match?(/[a-z]/) && captured_piece.match?(/[A-Z]/))
    end

    def self.opponent_color(active_color)
      active_color == 'w' ? 'b' : 'w'
    end
  end
end
