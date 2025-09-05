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
  class Display
    using Chess::ColorizeString
    attr_reader :board_data

    def self.show_board(...)
      new(...).build_board_for_display
    end

    # board_data is the grid information only from Board class
    # expect to receive board.to_display as board_data
    def initialize(board_data)
      @board_data = board_data
    end

    def map_piece_symbol(code)
      Chess::Piece::PIECE_SYMBOLS[code]
    end

    def build_board_for_display
      [
        build_top_border,
        build_file_labels,
        build_board_ranks,
        build_file_labels,
        build_bottom_border
      ].join("\n")
    end

    private

    def format_rank(rank, rank_index)
      rank.map.with_index do |piece_code, file_index|
        format_square(piece_code, rank_index, file_index)
      end.join
    end

    def format_square(piece_code, rank_index, file_index)
      combined_indices = rank_index + file_index
      apply_style_rules(combined_indices, piece_code)
    end

    def apply_style_rules(index, piece_code)
      content = apply_whitespace_style(piece_code)
      apply_background_color(index, content)
    end

    def apply_whitespace_style(piece_code)
      return Chess::Config::EMPTY_SQUARE_PADDING if piece_code.empty?

      "#{Chess::Config::PIECE_PADDING}#{map_piece_symbol(piece_code)}#{Chess::Config::PIECE_PADDING}"
    end

    def apply_background_color(index, content)
      # "white on the right"
      color = index.even? ? :white : :black
      content.output_color(color, ground: 'back')
    end

    def build_board_ranks
      board_data.map.with_index do |rank, rank_index|
        rank_number = Chess::Config::GRID_LENGTH - rank_index
        formatted_rank = format_rank(rank, rank_index)
        "#{rank_number} #{formatted_rank} #{rank_number}"
      end
    end

    def build_top_border
      "  ╔#{'═══' * Chess::Config::GRID_LENGTH}╗"
    end

    def build_bottom_border
      "  ╚#{'═══' * Chess::Config::GRID_LENGTH}╝"
    end

    def build_file_labels
      files = ('a'..'h').first(Chess::Config::GRID_LENGTH)
      "    #{files.map { |f| f.center(3) }.join}  "
    end
  end
end
