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
      opponent_color = PieceHelpers.opponent_color(active_color)
      # retrieve data on all of opponent's pieces & their positions
      opponent_piece_data = board.find_all_pieces(opponent_color)
      # calculate all moves possible from opponent pieces
      p opponent_moves = find_all_pieces_moves(opponent_piece_data)
    end

    private

    def find_all_pieces_moves(piece_data)
      possible_move_positions = []
      piece_data.each do |position, piece|
        position[:position]
      end
    end
  end
end
