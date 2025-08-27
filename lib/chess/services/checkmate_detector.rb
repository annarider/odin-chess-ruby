module Chess
  # Checkmate Detector checks whether
  # checkmate conditions are achieved.
  # This class relies on CheckDetector
  # to determine if the king is in check.
  #
  # Then it decides if there are any
  # legal moves for the king to take.
  class CheckmateDetector
    attr_reader :board, :active_color, :king_position

    def self.checkmate?(...)
      new(...).checkmate?
    end

    def initialize(board, active_color, king_position = nil)
      @board = board
      @active_color = active_color
      @king_position = king_position || locate_king
    end

    def checkmate?
      return false unless CheckDetector.in_check?(board, active_color,
                                                  king_position)
      return false if king_evade_check?
      return false if capture_attacker?
      return false if friendly_shield_king?

      true
    end

    private

    def locate_king
      board.find_king(active_color)
    end

    def king_evade_check?
      king_moves = valid_moves(king_position, query_piece)
      # stalemate: king has no legal moves and not in check
      return false if king_moves.empty?

      king_moves.any? do |test_position|
        !CheckDetector.in_check?(board, active_color, test_position)
      end
    end

    def capture_attacker?
      # get all opponent pieces giving check
      attacker_pieces_data = find_attacker_positions
      # get all friendly pieces and their validated moves
      friendly_pieces_moves = find_friendly_moves
      # can friendly pieces move to capture attacking piece?
      friendly_pieces_moves.any? do |move|
        attacker_pieces_data.any? do |attacker_position|
          move.to_position == attacker_position
        end
      end
    end

    def find_attacker_positions
      opponent_color = PieceHelpers.opponent_color(active_color)
      # retrieve data on all of opponent's pieces & their positions
      opponent_pieces_data = board.find_all_pieces(opponent_color)
      # get all valid opponent moves
      opponent_moves = opponent_pieces_data.flat_map do |piece_data|
        valid_moves(piece_data[:position], piece_data[:piece])
      end
      # filter only opponent positions that can attack the king
      # return piece positions
      attacking_moves = opponent_moves.select do |move|
        move.to_position == king_position
      end
      attacking_moves.map(&:from_position).uniq
    end

    def find_friendly_moves
      friendly_pieces = board.find_all_pieces(active_color)
      # get all valid friendly moves
      friendly_pieces.flat_map do |piece_hash|
        valid_moves(piece_hash[:position], piece_hash[:piece])
      end
    end

    def valid_moves(start_position, piece)
      positions = MoveCalculator.generate_possible_moves(start_position, piece)
      moves = positions.map do |end_position|
        Move.new(from_position: start_position,
                        to_position: end_position, piece: piece)
      end
      moves.select { |move| MoveValidator.move_legal?(board, move) }
    end

    def friendly_shield_king?
      # get all friendly pieces and their possible moves
      friendly_moves = find_friendly_moves
      friendly_moves.none? do |from_pos, to_pos|
        # deep copy board to play out move scenarios
        test_board = board.deep_copy
        test_board.update_position(from_pos, to_pos)
        CheckDetector.in_check?(test_board, active_color, king_position)
      end
      false
    end

    def query_piece
      active_color == ChessNotation::WHITE_PLAYER ? 'K' : 'k'
    end
  end
end
