module Chess
  # Checkmate Detector checks whether
  # checkmate conditions are achieved.
  # This class relies on CheckDetector
  # to determine if the king is in check.
  #
  # Then it decides if there are any
  # legal moves for the king to take.
  class CheckmateDetector
    attr_reader :board

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

    def query_piece
      active_color == ChessNotation::WHITE_PLAYER ? 'K' : 'k'
    end
  end
end
