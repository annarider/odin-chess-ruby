# frozen_string_literal: true

module Chess
  # InsufficientMaterialDetector checks whether
  # there is insufficient material on the board
  # to achieve checkmate, resulting in a draw.
  #
  # Insufficient material cases:
  # - King vs King
  # - King + Bishop vs King
  # - King + Knight vs King  
  # - King + Bishop vs King + Bishop (same color squares)
  class InsufficientMaterialDetector
    include Piece
    attr_reader :board

    def self.insufficient_material?(board)
      new(board).insufficient_material?
    end

    def initialize(board)
      @board = board
    end

    def insufficient_material?
      pieces = collect_all_pieces
      return true if king_vs_king?(pieces)
      return true if king_and_minor_vs_king?(pieces)
      return true if king_bishop_vs_king_bishop_same_color?(pieces)

      false
    end

    private

    def collect_all_pieces
      white_pieces = board.find_all_pieces(ChessNotation::WHITE_PLAYER)
      black_pieces = board.find_all_pieces(ChessNotation::BLACK_PLAYER)
      
      {
        white: white_pieces.map { |piece_data| piece_data[:piece].downcase },
        black: black_pieces.map { |piece_data| piece_data[:piece].downcase }
      }
    end

    def king_vs_king?(pieces)
      pieces[:white].sort == ['k'] && pieces[:black].sort == ['k']
    end

    def king_and_minor_vs_king?(pieces)
      white_pieces = pieces[:white].sort
      black_pieces = pieces[:black].sort
      
      (white_pieces == ['k'] && minor_piece_only?(black_pieces)) ||
        (black_pieces == ['k'] && minor_piece_only?(white_pieces))
    end

    def minor_piece_only?(pieces)
      pieces == ['b', 'k'] || pieces == ['k', 'n']
    end

    def king_bishop_vs_king_bishop_same_color?(pieces)
      white_pieces = pieces[:white].sort
      black_pieces = pieces[:black].sort
      
      return false unless white_pieces == ['b', 'k'] && black_pieces == ['b', 'k']
      
      white_bishop_pos = find_piece_position('B')
      black_bishop_pos = find_piece_position('b')
      
      return false if white_bishop_pos.nil? || black_bishop_pos.nil?
      
      same_color_squares?(white_bishop_pos, black_bishop_pos)
    end

    def find_piece_position(target_piece)
      board.each_square do |piece, row, col|
        return Position.new(row, col) if piece == target_piece
      end
      nil
    end

    def same_color_squares?(pos1, pos2)
      square1_color = (pos1.row + pos1.column).even?
      square2_color = (pos2.row + pos2.column).even?
      square1_color == square2_color
    end
  end
end