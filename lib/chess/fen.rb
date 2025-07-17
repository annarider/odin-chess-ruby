# frozen_string_literal: true

module Chess
  # Helper methods to convert current
  # game state to Forsyth–Edwards
  # Notation in Chess game
  module FEN
    # starting position FEN:
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    def create_fen(board)
      build_piece_placement(board.grid)
    end

    private

    def build_piece_placement(grid)
      grid.map { |rank| build_rank(rank) }
    end

    def build_rank(rank)
      grouped_squares = rank.slice_when { |left, right| left.nil? != right.nil? }.to_a
      if nested_array?(grouped_squares)
        parse_squares(grouped_squares)
      else
        grouped_squares.join
      end
    end

    def nested_array?(array)
      array.any? { |element| element.is_a?(Array) }
    end
  end
end
