# frozen_string_literal: true

module Chess
  # Utility methods related to
  # querying piece data
  module PieceHelpers
    # checks if the captured piece is an enemy color
    def self.opponent_color?(attack_piece:, captured_piece:)
      (attack_piece.match?(/[A-Z]/) && captured_piece.match?(/[a-z]/)) ||
        (attack_piece.match?(/[a-z]/) && captured_piece.match?(/[A-Z]/))
    end

    def self.opponent_color(active_color)
      active_color == Chess::ChessNotation::WHITE_PLAYER ? Chess::ChessNotation::BLACK_PLAYER : Chess::ChessNotation::WHITE_PLAYER
    end

    def self.friendly_piece?(color:, target_piece:)
      # if it's white's piece
      if color == Chess::ChessNotation::WHITE_PLAYER
        target_piece.match?(/[A-Z]/)
      elsif color == Chess::ChessNotation::BLACK_PLAYER
        target_piece.match?(/[a-z]/)
      end
    end

    def self.calculate_color(piece)
      return nil unless piece

      if piece.match?(/[A-Z]/)
        Chess::ChessNotation::WHITE_PLAYER
      else
        Chess::ChessNotation::BLACK_PLAYER
      end
    end
  end
end
