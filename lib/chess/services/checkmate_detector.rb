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
      valid_moves = valid_moves(king_position, query_piece)
      # stalemate: king has no legal moves and not in check
      return false if valid_moves.empty?

      valid_moves.any? do |test_position|
        !CheckDetector.in_check?(board, active_color, test_position)
      end
    end

    def capture_attacker?
      # get all opponent pieces giving check
      attacker_positions = find_attacker_positions
      # get all friendly pieces and their possible moves
      friendly_pieces_moves = find_friendly_moves
      # can friendly pieces move to capture attacking piece?
      friendly_pieces_moves.any? do |piece_moves|
        piece_moves.any? do |move|
          attacker_positions.each do |opponent_position|
            move.to_position == opponent_position
          end
        end
      end
    end

    def find_attacker_positions
      opponent_positions = CheckDetector.find_opponent_moves(board, active_color,
                                                         king_position)
      opponent_positions.select do |opponent_position|
        opponent_position == king_position
      end
    end

    def find_friendly_moves
      friendly_pieces = board.find_all_pieces(active_color)
      friendly_pieces.map do |piece_hash|
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
