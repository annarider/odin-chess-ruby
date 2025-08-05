# frozen_string_literal: true

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
    extend ChessNotation
    attr_accessor :grid, :castling_rights, :en_passant_square

    def initialize(grid: self.class.empty_grid,
                   castling_rights: self.class.default_castling_rights,
                   en_passant_square: nil)
      @grid = grid
      @castling_rights = castling_rights
      @en_passant_square = en_passant_square
    end

    class << self
      def start_positions(add_pieces: true)
        setup_starting_grid = add_pieces ? setup_pieces(empty_grid) : empty_grid
        new(grid: setup_starting_grid)
      end

      def from_fen(fen_string)
        parsed_data = FromFEN.to_piece_placement(fen_string)
        new(**parsed_data)
      end

      def empty_grid
        Array.new(Config::GRID_LENGTH) { Array.new(Config::GRID_LENGTH) }
      end

      def default_castling_rights
        {
          white_castle_kingside: true,
          white_castle_queenside: true,
          black_castle_kingside: true,
          black_castle_queenside: true
        }
      end

      private

      def setup_pieces(grid)
        Piece::START_POSITIONS.each do |(rank, file), piece|
          grid[rank][file] = piece
        end
        grid
      end
    end

    def to_display
      grid.map { |rank| rank.map { |file| file.nil? ? '' : file.to_s } }
    end

    def to_fen
      {
        grid: grid,
        castling_rights: castling_rights,
        en_passant_square: en_passant_square
      }
    end

    def piece_at(position)
      grid[position.row][position.column]
    end

    # command to update grid state when piece moves
    def update_position(start_pos, end_pos)
      piece = piece_at(start_pos)
      place_piece(end_pos, piece)
      erase_origin_position(start_pos)
    end

    def place_piece(position, piece)
      @grid[position.row][position.column] = piece
    end

    # 4 steps to a move:
    # 1. check move is valid
    # 2. create new position
    # 3. update board state (grid, flags, etc.)
    # 4. return status
    def try_move(move)
      return :no_piece if possible_move.empty?
      return :illegal_move unless valid_move?(move)

      play_move(move)
      :success
    end

    def valid_move?(move)
      MoveValidator.is_move_legal?(self, move)
    end

    def play_move(move)
      update_position(move.from_position, move.to_position)
      update_castling_rights(move)
      update_en_passant_square(move)
    end

    private

    def possible_moves(position)
      return [] if piece_at(position).nil?

      generate_possible_moves(position, piece_at(position))
    end

    def erase_origin_position(start_pos)
      @grid[start_pos.row][start_pos.column] = nil
    end

    def update_en_passant_square(move)
      @en_passant_square = nil # reset en passant square
      if %w[p P].include?(move.piece) && pawn_advanced_two_squares?(move)
      end
    end

    def pawn_advanced_two_squares?(move)
      
    end
  end
end
