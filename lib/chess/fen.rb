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
      fen_string += "#{build_castling_rights(board)} "
      fen_string += "#{build_en_passant(board.en_passant_square)} "
      fen_string += "#{board.half_move_clock} "
      fen_string + board.full_move_number.to_s
    end

    def parse_fen(fen_string)
      fen_fields = split_fen_string(fen_string)
      flat_grid = split_board_grid(fen_fields[:grid])
      board_grid = counts_to_nil!(flat_grid) if flat_grid.any? { |rank| is_numeric?(rank) }
      fen_fields[:grid] = string_pieces_to_array(board_grid) if board_grid.any? { |rank| rank.is_a?(String) }
      fen_fields
    end

    private

    # create fen string helper methods
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

    def build_castling_rights(board)
      "#{board.white_castle_kingside}#{board.white_castle_queenside}" \
        "#{board.black_castle_kingside}#{board.black_castle_queenside}"
    end

    def build_en_passant(square)
      return '-' if square.nil?

      square
    end

    # parse fen string helper methods
    def split_fen_string(fen_string)
      fen_fields = fen_string.split
      return nil unless fen_fields.length == 6

      {
        grid: fen_fields[0],
        active_color: fen_fields[1],
        castling_rights: fen_fields[2],
        en_passant_square: fen_fields[3],
        half_move_clock: fen_fields[4].to_i,
        full_move_number: fen_fields[5].to_i
      }
    end

    def split_board_grid(fen_placement_string)
      fen_placement_string.split('/')
    end

    def is_numeric?(string)
      string.scan(/\D/).empty?
    end

    def counts_to_nil!(flat_grid)
      flat_grid.map do |rank|
        if is_numeric?(rank)
          count = rank.to_i
          rank = Array.new(count, nil)
        else
          rank
        end
      end
    end

    def string_pieces_to_array(grid)
      grid.map do |rank|
        if rank.is_a?(String)
          rank.chars
        else
          rank 
        end
      end 
    end

    def split_castling_rights(castling_symbol)
      if castling_symbol.include?(Chess::ChessNotation::NEITHER_CASTLE_RIGHTS)
        @white_castle_kingside
      end
    end
  end
end
