# frozen_string_literal: true

module Chess
  class CheckDetector
    attr_reader :board, :active_color

    def self.in_check?(...)
      new(...).in_check?
    end

    def initialize(board, active_color)
      @board = board
      @active_color = active_color
    end

    def in_check?
      king_position = board.find_king(active_color)
      return false unless king_position

      opponent_color = PieceHelpers.opponent_color(active_color)
      # retrieve data on all of opponent's pieces & their positions
      opponent_pieces = board.find_all_pieces(opponent_color)
      # calculate all moves possible from opponent pieces
      opponent_moves = find_all_pieces_moves(opponent_pieces)
      find_king_in_opponent_moves?(king_position, opponent_moves)
    end

    private

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
