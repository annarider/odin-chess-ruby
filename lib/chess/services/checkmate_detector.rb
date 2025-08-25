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
      king_moves = MoveCalculator.generate_possible_moves(king_position,
                                                          query_piece)
      check_detection = king_moves.map do |position|
        CheckDetector.in_check?(board, active_color, position)
      end
      check_detection.any? { |check_status| check_status == false }
    end

    def capture_attacker?
      # get all opponent pieces giving check
      attacker_moves = find_attacker_moves
      # get all friendly pieces and their possible moves
      friendly_moves = find_friendly_moves
      # can friendly pieces move to capture attacking piece?
      friendly_moves.any? do |friendly_piece_hash|
        attacker_moves.each do |opponent_piece_hash|
          friendly_piece_hash[:position] == opponent_piece_hash[:position]
        end
      end
    end

    def find_attacker_moves
      opponent_moves = CheckDetector.find_opponent_moves(board, active_color,
                                                         king_position)
      opponent_moves.select do |piece_hash|
        piece_hash[:position] == king_position
      end
    end

    def find_friendly_moves
      friendly_pieces = board.find_all_pieces(active_color)
      friendly_pieces.map do |piece_hash|
        MoveCalculator.generate_possible_moves(piece_hash[:position],
                                               piece_hash[:piece])
      end
    end

    def friendly_shield_king?
      # get all friendly pieces and their possible moves
      friendly_moves = find_friendly_moves
      # can any of these friendly moves defend the king from attackers?
    end

    def query_piece
      active_color == ChessNotation::WHITE_PLAYER ? 'K' : 'k'
    end
  end
end
