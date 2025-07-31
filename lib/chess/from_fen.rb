# frozen_string_literal: true

module Chess
  # Helper methods to convert
  # Forsyth–Edwards Notation
  # into a Chess game
  class FromFEN
    attr_reader :fen_string

    def self.parse_fen(...)
      new(...).parse_fen
    end

    def self.to_piece_placement(...)
      new(...).parse_fen_for_piece_placement
    end

    def initialize(fen_string)
      @fen_string = fen_string
    end

    # starting position FEN:
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    def parse_fen
      split_fen_string
    end

    # return only first 4 fields for Board
    def parse_fen_for_piece_placement
      fields = split_fen_string
      fields.delete_if do
        |key, _v| key.to_s.include?('move') ||
          key.to_s.include?('active')
      end
    end

    private

    # parse fen string helper methods
    def split_fen_string
      fen_fields = fen_string.split
      return nil unless fen_fields.length == 6

      castling_rights = fen_fields[2]

      {
        grid: parse_piece_placement(fen_fields[0]),
        active_color: fen_fields[1],
        castling_rights_hash: build_castling_rights(castling_rights),
        en_passant_square: en_passant_to_position(fen_fields[3]),
        half_move_clock: fen_fields[4].to_i,
        full_move_number: fen_fields[5].to_i
      }
    end

    def parse_piece_placement(grid_data)
      ranks = grid_data.split('/')
      ranks.map do |rank|
        expand_rank_notation(rank)
      end
    end

    def expand_rank_notation(rank)
      rank.chars.flat_map do |char|
        if char.match?(/\d/)
          Array.new(char.to_i, nil)
        else
          char
        end
      end
    end

    def build_castling_rights(castling_string)
      {
        white_castle_kingside: can_castle?(castling_string, ChessNotation::WHITE_CASTLE_KINGSIDE),
        white_castle_queenside: can_castle?(castling_string, ChessNotation::WHITE_CASTLE_QUEENSIDE),
        black_castle_kingside: can_castle?(castling_string, ChessNotation::BLACK_CASTLE_KINGSIDE),
        black_castle_queenside: can_castle?(castling_string, ChessNotation::BLACK_CASTLE_QUEENSIDE)
      }
    end

    def can_castle?(castling_symbol, castle_type)
      castling_symbol.include?(castle_type)
    end

    def en_passant_to_position(field)
      return nil if field == '-'

      Position.from_algebraic(field)
    end
  end
end
