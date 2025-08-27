# frozen_string_literal: true

module Chess
  class CheckDetector
    attr_reader :board, :active_color, :king_position

    def self.in_check?(...)
      new(...).in_check?
    end

    def self.find_opponent_moves(...)
      new(...).find_opponent_moves
    end

    def initialize(board, active_color, king_position = nil)
      @board = board
      @active_color = active_color
      @king_position = king_position || setup_king
    end

    def in_check?
      opponent_moves = find_opponent_moves
      find_king_in_opponent_moves?(king_position, opponent_moves)
    end

    private

    def setup_king
      board.find_king(active_color)
    end

    def find_opponent_moves
      opponent_color = PieceHelpers.opponent_color(active_color)
      # retrieve data on all of opponent's pieces & their positions
      opponent_pieces = board.find_all_pieces(opponent_color)
      # calculate all moves possible from opponent pieces
      find_all_pieces_moves(opponent_pieces)
    end

    def find_all_pieces_moves(piece_data)
      piece_data.flat_map do |piece_hash|
        MoveCalculator.generate_possible_moves(
          piece_hash[:position],
          piece_hash[:piece]
        )
      end
    end

    def find_king_in_opponent_moves?(king_position, opponent_moves)
      opponent_moves.any? { |position| position == king_position }
    end
  end
end
