# frozen_string_literal: true

module Chess
  # Helper methods to convert
  # Forsyth–Edwards Notation
  # into a Chess game
  module FromFEN
    # starting position FEN:
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    def parse_fen(fen_string)
      split_fen_string(fen_string)
    end

    private

    # parse fen string helper methods
    def split_fen_string(fen_string)
      fen_fields = fen_string.split
      return nil unless fen_fields.length == 6

      castling_rights = fen_fields[2]

      {
        grid: parse_piece_placement(fen_fields[0]),
        active_color: fen_fields[1],
        white_castle_kingside: can_castle?(castling_rights, Chess::ChessNotation::WHITE_CASTLE_KINGSIDE),
        white_castle_queenside: can_castle?(castling_rights, Chess::ChessNotation::WHITE_CASTLE_QUEENSIDE),
        black_castle_kingside: can_castle?(castling_rights, ChessNotation::BLACK_CASTLE_KINGSIDE),
        black_castle_queenside: can_castle?(castling_rights, Chess::ChessNotation::BLACK_CASTLE_QUEENSIDE),
        en_passant_square: en_passant_to_position(fen_fields[3]),
        half_move_clock: fen_fields[4].to_i,
        full_move_number: fen_fields[5].to_i
      }
    end

    def parse_piece_placement(grid_data)
      flat_grid = split_board_grid(grid_data)
      board_grid = convert_numeric_nils!(flat_grid) if flat_grid.any? { |rank| numeric?(rank) }
      string_pieces_to_array(board_grid) if board_grid.any? { |rank| rank.is_a?(String) }
    end

    def split_board_grid(fen_placement_string)
      fen_placement_string.split('/')
    end

    def numeric?(string)
      string.scan(/\d/).any?
    end

    def convert_numeric_nils!(flat_grid)
      flat_grid.map do |rank|
        if rank == '8'
          counts_to_nil(rank)
        elsif numeric?(rank) && rank.length > 1
          parse_rank_nils(rank).flatten
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

    def can_castle?(castling_symbol, castle_type)
      castling_symbol.include?(castle_type)
    end

    def parse_rank_nils(rank)
      split_rank = rank.chars
      split_rank.map do |square| 
        if numeric?(square)
          counts_to_nil(square)
        else
          square
        end 
      end
    end
    
    def counts_to_nil(rank)
      count = rank.to_i
      Array.new(count, nil)
    end

    def en_passant_to_position(field)
      return field if field == '-'

      Chess::Position.from_algebraic(field)
    end
  end
end
