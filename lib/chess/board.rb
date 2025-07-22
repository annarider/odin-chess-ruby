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
    include Chess::FromFEN
    include Chess::ToFEN
    include Chess::MoveCalculator
    extend Chess::FromFEN
    extend Chess::ToFEN
    extend Chess::ChessNotation
    attr_accessor :grid, :active_color, :white_castle_kingside,
                  :white_castle_queenside, :black_castle_kingside,
                  :black_castle_queenside, :en_passant_square, :half_move_clock,
                  :full_move_number

    def initialize(grid: self.class.empty_grid,
                   active_color: Chess::ChessNotation::WHITE_PLAYER,
                   white_castle_kingside: ChessNotation::WHITE_CASTLE_KINGSIDE,
                   white_castle_queenside: ChessNotation::WHITE_CASTLE_QUEENSIDE,
                   black_castle_kingside: ChessNotation::BLACK_CASTLE_KINGSIDE,
                   black_castle_queenside: ChessNotation::BLACK_CASTLE_QUEENSIDE,
                   en_passant_square: nil,
                   half_move_clock: 0,
                   full_move_number: 1)
      @grid = grid
      @active_color = active_color
      @white_castle_kingside = white_castle_kingside
      @white_castle_queenside = white_castle_queenside
      @black_castle_kingside = black_castle_kingside
      @black_castle_queenside = black_castle_queenside
      @en_passant_square = en_passant_square
      @half_move_clock = half_move_clock
      @full_move_number = full_move_number
    end

    class << self
      def initial_start(add_pieces: true)
        setup_starting_grid = add_pieces ? setup_pieces(empty_grid) : empty_grid
        new(grid: setup_starting_grid)
      end

      def from_fen(fen_string)
        parsed_data = parse_fen(fen_string)
        new(**parsed_data)
      end

      def empty_grid
        Array.new(Chess::Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
      end

      private

      def setup_pieces(grid)
        Chess::Piece::INITIAL_POSITIONS.each do |(rank, file), piece|
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

    # 4 steps to a move:
    # 1. check move is valid
    # 2. create new position
    # 3. update game state (grid, flags, etc.)
    # 4. return status
    def try_move(move)
      return :no_piece if piece_at(move.from_position).nil?
      return false unless valid_move?(self, move)

      play_move(move)
    end

    def possible_moves(position)
      return :no_piece if piece_at(position).nil?

      generate_possible_moves(position, piece_at(position))
    end

    def place_piece(position, piece)
      @grid[position.row][position.column] = piece
    end
  end
end
