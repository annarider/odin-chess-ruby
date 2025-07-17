# frozen_string_literal: true

require_relative 'config'

module Chess
  # Board represents a chess board.
  #
  # It contains the game board
  # and manages the rules of
  # the game.
  #
  # @example Create a new Board
  # board = Board.new
  #
  class Board
    include Chess::FEN
    extend Chess::ChessNotation
    attr_accessor :grid, :active_color, :white_castle_kingside,
      :white_castle_queenside, :black_castle_kingside,
      :black_castle_queenside, :en_passant_square, :half_move_clock,
      :full_move_number

    def initialize(grid, active_color:, white_castle_kingside:, 
      white_castle_queenside:, black_castle_kingside:,
      black_castle_queenside:, en_passant_square:, half_move_clock:,
      full_move_number:   
    )
      @grid = grid
    end

    class << self
      def initial_start(add_pieces: true)
        default_grid = Array.new(Chess::Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
        setup_pieces(default_grid) if add_pieces
        new(default_grid, active_color: Chess::ChessNotation::WHITE_PLAYER,
          white_castle_kingside: ChessNotation::WHITE_CASTLE_KINGSIDE,
          white_castle_queenside: ChessNotation::WHITE_CASTLE_QUEENSIDE,
          black_castle_kingside: ChessNotation::BLACK_CASTLE_KINGSIDE,
          black_castle_queenside: ChessNotation::BLACK_CASTLE_QUEENSIDE,
          en_passant_square: nil, half_move_clock: 0, full_move_number: 1
          )
      end

      private

      def setup_pieces(grid)
        Piece::INITIAL_POSITIONS.each do |(rank, file), piece|
          grid[rank][file] = piece
        end
        grid
      end
    end

    def to_display
      grid.map do |rank|
        rank.map do |file|
          if file.nil?
            ''
          else
            file.to_s
          end
        end
      end
    end

    def to_fen
      create_fen(self)
    end

    def piece_at(position)
      grid[position.row][position.column]
    end

    private
  end
end
