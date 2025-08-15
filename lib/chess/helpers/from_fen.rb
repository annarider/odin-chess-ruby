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

    def self.to_game_data(...)
      new(...).parse_fen_for_game_data
    end

    def initialize(fen_string)
      @fen_string = fen_string
    end

    # starting position FEN:
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    def parse_fen
      fen_fields = fen_string.split
      return nil unless fen_fields.length == 6

      split_fen_string(fen_fields)
    end

    # return only first 4 fields for Board.new
    def parse_fen_for_piece_placement
      fields = parse_fen
      fields.delete_if do |key, _v|
        key.to_s.include?('move') ||
          key.to_s.include?('active')
      end
    end

    def parse_fen_for_game_data
      fields = parse_fen
      fields.slice(:active_color, :half_move_clock, :full_move_number)
    end

    private

    # parse fen string helper methods
    def split_fen_string(fen_fields)
      castling_rights = fen_fields[2]

      {
        grid: parse_piece_placement(fen_fields[0]),
        active_color: convert_fen_active_color(fen_fields[1]),
        castling_rights: build_castling_rights(castling_rights),
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

    def convert_fen_active_color(fen_string)
      fen_string == 'w' ? :white : :black
    end
  end
end
