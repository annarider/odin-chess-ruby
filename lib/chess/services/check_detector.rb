module Chess
  class CheckDetector
    attr_reader :board, :active_color

    def self.in_check?(...)
      new(...).in_check?
    end

    def initialize(board, active_color)
      @board = board
      @active_color = active_color
    end

    def in_check?
      king_position = board.find_king(active_color)
      all_moves
    end
  end
end
