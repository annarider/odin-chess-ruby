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
        legal_moves(piece_hash[:position], piece_hash[:piece])
      end
    end

    def legal_moves(start_position, piece)
      moves = valid_moves(start_position, piece)
      moves.select { |move| move_leaves_king_safe?(move) }
    end

    def move_leaves_king_safe?(move, king_final_position = nil)
      test_board = board.deep_copy
      test_board.update_position(move.from_position, move.to_position)
      final_king_position = find_final_king_position(move, king_final_position)
      CheckDetector.in_check?(test_board, active_color, final_king_position) == false
    end

    def find_final_king_position(move, king_final_position)
      if king_final_position
        king_final_position
      elsif Piece::KING_PIECES.include?(move.piece)
        move.to_position
      else
        king_position
      end
    end
  end
end
