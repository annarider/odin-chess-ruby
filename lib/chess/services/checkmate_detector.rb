module Chess
  # Checkmate Detector checks whether
  # checkmate conditions are achieved.
  # This class relies on CheckDetector
  # to determine if the king is in check.
  #
  # Then it decides if there are any
  # legal moves for the king to take.
  class CheckmateDetector
    include GameAnalysis
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


    def king_evade_check?
      king_moves = valid_moves(king_position, query_piece)
      # stalemate: king has no legal moves and not in check
      return false if king_moves.empty?

      king_moves.any? do |move|
        king_can_escape_to?(move.to_position, move)
      end
    end

    def king_can_escape_to?(end_position, move)
      # king escapes if it's NOT in check after the move
      move_leaves_king_safe?(move, end_position)
    end


    def capture_attacker?
      # get all opponent pieces giving check
      attacker_pieces_data = find_attacker_positions
      # get all friendly pieces and their validated moves
      friendly_pieces_moves = find_friendly_moves
      # can friendly pieces move to capture attacking piece AND leave king safe?
      friendly_pieces_moves.any? do |move|
        if attacker_pieces_data.include?(move.to_position)
          move_leaves_king_safe?(move)
        else
          false
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

    def friendly_shield_king?
      # get all friendly pieces and their possible moves
      friendly_moves = find_friendly_moves
      friendly_moves.none? do |move|
        # deep copy board to play out move scenarios
        move_leaves_king_safe?(move)
      end
      false
    end

    def query_piece
      active_color == ChessNotation::WHITE_PLAYER ? 'K' : 'k'
    end
  end
end
