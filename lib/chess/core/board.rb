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
    attr_accessor :grid, :castling_rights, :en_passant_target

    def initialize(grid: self.class.empty_grid,
                   castling_rights: self.class.default_castling_rights,
                   en_passant_target: nil)
      @grid = grid
      @castling_rights = castling_rights
      @en_passant_target = en_passant_target
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
        en_passant_target: en_passant_target
      }
    end

    def deep_copy
      new_board = Board.new(
        castling_rights: castling_rights.dup,
        en_passant_target: en_passant_target
      )
      grid.each_with_index do |row, row_index|
        row.each_with_index do |_piece, column_index|
          position = Position.new(row_index, column_index)
          piece = piece_at(position)
          new_board.place_piece(position, piece) if piece
        end
      end
      new_board
    end

    def piece_at(position)
      grid[position.row][position.column]
    end

    def find_king(color)
      target_piece = color == Chess::ChessNotation::WHITE_PLAYER ? 'K' : 'k'
      each_square do |piece, row_index, col_index|
        return Position.new(row_index, col_index) if piece == target_piece
      end
    end

    def find_all_pieces(color)
      pieces = []
      each_square do |piece, row, column|
        next if piece.nil?

        if PieceHelpers.friendly_piece?(color: color, target_piece: piece)
          pieces << { position: Position.new(row, column), piece: piece }
        end
      end
      pieces
    end

    # command to update grid state when piece moves
    def update_position(start_pos, end_pos)
      piece = piece_at(start_pos)
      raise ArgumentError, "No piece at #{start_pos}" unless piece

      place_piece(end_pos, piece)
      remove_piece(start_pos)
    end

    def place_piece(position, piece)
      @grid[position.row][position.column] = piece
    end

    def remove_piece(position)
      @grid[position.row][position.column] = nil
    end

    def valid_move?(move)
      MoveValidator.move_legal?(self, move)
    end

    def update_en_passant_target(move)
      @en_passant_target = nil # reset en passant square
      if Piece::PAWN_PIECES.include?(move.piece) && pawn_advanced_two_squares?(move)
        target_row = move.from_position.row + ((move.to_position.row - move.from_position.row) / 2)
        @en_passant_target = Position.new(target_row, move.to_position.column)
      end
    end

    def update_castling_rights(move)
      piece = move.piece
      from_position = move.from_position
      
      # King moves - lose all castling rights for that color
      if piece == 'K' # White king
        @castling_rights[:white_castle_kingside] = false
        @castling_rights[:white_castle_queenside] = false
      elsif piece == 'k' # Black king
        @castling_rights[:black_castle_kingside] = false
        @castling_rights[:black_castle_queenside] = false
      # Rook moves from starting position - lose castling rights for that side
      elsif piece == 'R' # White rook
        if from_position.rank == '1' && from_position.file == 'a'
          @castling_rights[:white_castle_queenside] = false
        elsif from_position.rank == '1' && from_position.file == 'h'
          @castling_rights[:white_castle_kingside] = false
        end
      elsif piece == 'r' # Black rook
        if from_position.rank == '8' && from_position.file == 'a'
          @castling_rights[:black_castle_queenside] = false
        elsif from_position.rank == '8' && from_position.file == 'h'
          @castling_rights[:black_castle_kingside] = false
        end
      end
    end

    private

    def each_square
      grid.each_with_index do |rank, row_index|
        rank.each_with_index do |piece, col_index|
          yield(piece, row_index, col_index)
        end
      end
    end

    def possible_moves(position)
      return [] if piece_at(position).nil?

      generate_possible_moves(position, piece_at(position))
    end

    def pawn_advanced_two_squares?(move)
      return false unless Piece::PAWN_PIECES.include?(move.piece)
      
      row_diff = (move.to_position.row - move.from_position.row).abs
      row_diff == 2
    end
  end
end
