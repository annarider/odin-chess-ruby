# frozen_string_literal: true

module Chess
  module GameAnalysis
    private

    def locate_king
      board.find_king(active_color)
    end

    def valid_moves(start_position, piece)
      positions = MoveCalculator.generate_possible_moves(start_position, piece)
      moves = positions.map do |end_position|
        Move.new(from_position: start_position,
                 to_position: end_position, piece: piece)
      end
      moves.select { |move| MoveValidator.move_legal?(board, move) }
    end

    def find_friendly_moves
      friendly_pieces = board.find_all_pieces(active_color)
      friendly_pieces.flat_map do |piece_hash|
        valid_moves(piece_hash[:position], piece_hash[:piece])
      end
    end
  end
end
