# frozen_string_literal: true

require_relative 'colorize_string'

module Chess
  # Display defines how to display
  # the game board in Chess.
  #
  # It manages displaying the board,
  # the pieces, and colors. It
  # doesn't include the IO
  # functionality in the game.
  #
  # @example Create a new Board
  # board = Board.new
  #
  module Display
    using ColorizeString

    def self.map_piece_symbol(code)
      Piece::PIECE_SYMBOLS[code]
    end

    def self.build_board_for_display(board)
      grid = board.to_display
      format_board(grid)
    end

    def self.format_board(grid)
      grid.map.with_index do |rank, rank_index|
        format_rank(rank, rank_index)
      end.join("\n")
    end

    def self.format_rank(rank, rank_index)
      rank.map.with_index do |piece_code, file_index|
        format_square(piece_code, rank_index, file_index)
      end.join
    end

    def self.format_square(piece_code, rank_index, file_index)
      combined_indices = rank_index + file_index
      apply_style_rules(combined_indices, piece_code)
    end

    def self.apply_style_rules(index, piece_code)
      content = apply_whitespace_style(piece_code)
      apply_background_color(index, content)
    end

    def self.apply_whitespace_style(piece_code)
      return Config::EMPTY_SQUARE_PADDING if piece_code.empty?

      "#{Config::PIECE_PADDING}#{map_piece_symbol(piece_code)}#{Config::PIECE_PADDING}"
    end

    def self.apply_background_color(index, content)
      # "white on the right"
      color = index.even? ? :white : :black
      content.output_color(color, ground: 'back')
    end
  end
end
