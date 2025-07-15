# frozen_string_literal: true

module Chess
  # Helper methods to use Chess
  # Notation in Chess game
  module ChessNotation
    FILES = %w[a b c d e f g h]

    def col_to_file(column_index)
      FILES.fetch(column_index)
    end

    def row_to_rank(row_index)
      return (Chess::Config::GRID_LENGTH - row_index).to_s if row_index.between?(0, Config::GRID_LENGTH - 1)

      raise ArgumentError, "Invalid row index #{row_index}, must be 0 to 7."
    end

    def coord_to_rank_file(column_index, row_index)
      col_to_file(column_index).to_s + row_to_rank(row_index).to_s
    end

    def rank_to_row(rank)
      return (Chess::Config::GRID_LENGTH - rank.to_i) if rank.to_i.between?(1, Chess::Config::GRID_LENGTH)

      raise ArgumentError, "Invalid rank #{rank}, must be 1 to 8."
    end

    def file_to_col(file)
      FILES.find_index { |f| f == file }
    end

    def rank_file_to_coord(algebraic_notation)
      rank, file = split_square_to_rank_file(algebraic_notation)
      [rank_to_row(rank), file_to_col(file)]
    end

    def split_square_to_rank_file(algebraic_notation)
      rank = algebraic_notation.chars.last
      file = algebraic_notation.chars.first
      [rank, file]
    end

    def valid_rank?(rank)
      rank.to_i.positive? && rank.to_i.between?(1, Chess::Config::GRID_LENGTH)
    end

    def valid_file?(file)
      FILES.include?(file)
    end

    def valid_rank_file?(algebraic_notation)
      rank, file = split_square_to_rank_file(algebraic_notation)
      valid_rank?(rank) && valid_file?(file)
    end
  end
end
