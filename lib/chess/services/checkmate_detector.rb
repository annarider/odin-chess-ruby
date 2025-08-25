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
      return false unless CheckDetector.in_check?(
        board,
        active_color,
        king_position
      )
      return false if king_evade_check?
      return false if capture_attacker?

      true
    end

    private

    def locate_king
      board.find_king(active_color)
    end

    def king_evade_check?
      king_moves = MoveCalculator.generate_possible_moves(
        king_position,
        query_piece
      )
      check_detection = king_moves.map do |coordinates|
        position = Position.new(coordinates.first, coordinates.last)
        CheckDetector.in_check?(board, active_color, position)
      end
      check_detection.any? { |check_status| check_status == false }
    end

    def capture_attacker?
      opponent_moves = CheckDetector.find_opponent_moves(
        board,
        active_color,
        king_position
        )
      attacker_moves = opponent_moves.select do |piece_hash|
        piece_hash[:position] == king_position
      end
      friendly_pieces = board.find_all_pieces(active_color)
      friendly_moves = friendly_pieces.map do |piece_hash|
        MoveCalculator.generate_possible_moves(
          piece_hash[:position],
          piece_hash[:piece]
        )
      end
      friendly_moves.any? do |friendly_piece_hash|
        attacker_moves.each do |opponent_piece_hash|
          friendly_piece_hash[:position] == opponent_piece_hash[:position]
        end
      end
    end

    def query_piece
      active_color == ChessNotation::WHITE_PLAYER ? 'K' : 'k'
    end
  end
end
