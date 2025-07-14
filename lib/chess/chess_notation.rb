# frozen_string_literal: true

module Chess
  # Helper methods to use Chess
  # Notation in Chess game
  module ChessNotation
    FILES = %w[a b c d e f g h]

    def convert_num_to_file(column_index)
      FILES.fetch(column_index)
    end

    def convert_num_to_rank(row_index)
      return (Chess::Config::GRID_LENGTH - row_index).to_s if row_index.between?(0, Config::GRID_LENGTH - 1)

      raise ArgumentError, "Invalid row index #{row_index}, must be 0 to 7."
    end

    def convert_num_to_rank_file(column_index, row_index)
      convert_num_to_file(column_index).to_s + convert_num_to_rank(row_index).to_s
    end

    def convert_rank_to_num(rank)
      return (Chess::Config::GRID_LENGTH - rank.to_i) if rank.to_i.between?(1, Chess::Config::GRID_LENGTH)

      raise ArgumentError, "Invalid rank #{rank}, must be 1 to 8."
    end

    def convert_file_to_num(file)
      FILES.find_index { |f| f == file }
    end

    def convert_rank_file_to_num(algebraic_notation)
      file = algebraic_notation.chars.first
      rank = algebraic_notation.chars.last
      [convert_rank_to_num(rank), convert_file_to_num(file)]
    end
  end
end
