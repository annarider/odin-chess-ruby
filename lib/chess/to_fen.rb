# frozen_string_literal: true

module Chess
  # Helper methods to convert current
  # game state to Forsyth–Edwards
  # Notation in Chess game
  class ToFEN
    attr_reader :fen_data

    def self.create_fen(...)
      new(...).create_fen
    end

    def initialize(fen_data)
      @fen_data = fen_data
    end

    # starting position FEN:
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    def create_fen
      fen_string = ''
      fen_string += "#{build_piece_placement(fen_data.grid)} "
      fen_string += "#{fen_data.active_color} "
      fen_string += "#{build_castling_rights(fen_data.castling_rights)} "
      fen_string += "#{build_en_passant(fen_data.en_passant_square)} "
      fen_string += "#{fen_data.half_move_clock} "
      fen_string + fen_data.full_move_number.to_s
    end

    private

    # create fen string helper methods
    def build_piece_placement(grid)
      grid.map.with_index do |rank, _index|
        build_rank(rank)
      end.join('/')
    end

    def build_rank(rank)
      grouped_squares = rank.slice_when { |left, right| left.nil? != right.nil? }.to_a
      count_if_nils(grouped_squares).join
    end

    def count_if_nils(grouped_squares)
      grouped_squares.map do |group|
        if group.first.nil?
          group.length.to_s # convert nil count to string
        else
          group.join # join piece data without count
        end
      end
    end

    def build_castling_rights(castling_rights)
      rights = ''
      rights += 'K' if castling_rights[:white_castle_kingside]
      rights += 'Q' if castling_rights[:white_castle_queenside]
      rights += 'k' if castling_rights[:black_castle_kingside]
      rights += 'q' if castling_rights[:black_castle_queenside]
      rights.empty? ? '-' : rights
    end

    def build_en_passant(square)
      return '-' if square.nil?

      square
    end
  end
end
