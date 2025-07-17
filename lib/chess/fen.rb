# frozen_string_literal: true

module Chess
  # Helper methods to convert current
  # game state to Forsyth–Edwards
  # Notation in Chess game
  module FEN
    # starting position FEN:
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    def create_fen(board)
      fen_string = ''
      fen_string += "#{build_piece_placement(board.grid)} "
      fen_string += "#{board.active_color} "
      fen_string
    end

    private

    def build_piece_placement(grid)
      fen_placement_string = ''
      grid.each_with_index do |rank, index|
        fen_placement_string += build_rank(rank)
        fen_placement_string.concat('/') if index < Chess::Config::GRID_LENGTH - 1
      end
      fen_placement_string
    end

    def build_rank(rank)
      grouped_squares = rank.slice_when { |left, right| left.nil? != right.nil? }.to_a
      # p grouped_squares
      grouped_squares = count_nils(grouped_squares) if any_nils?(grouped_squares.flatten)
      grouped_squares.join
    end

    def any_nils?(array)
      array.any?(&:nil?)
    end

    def count_nils(array)
      array.map { |element| element.count(nil) }
    end
  end
end
