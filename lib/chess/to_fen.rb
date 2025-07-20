# frozen_string_literal: true

module Chess
  # Helper methods to convert current
  # game state to Forsyth–Edwards
  # Notation in Chess game
  module ToFEN
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

    private

    # create fen string helper methods
    def build_piece_placement(grid)
      grid.map.with_index do |rank, index|
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

    def build_castling_rights(board)
      rights = ''
      rights += 'K' if board.white_castle_kingside
      rights += 'Q' if board.white_castle_queenside
      rights += 'k' if board.black_castle_kingside
      rights += 'q' if board.black_castle_queenside
      rights.empty? ? '-' : rights
    end

    def build_en_passant(square)
      return '-' if square.nil?

      square
    end
  end
end
