module Chess
  # Find all the squares between start and destination positions
  class PathCalculator
    attr_reader :board, :start_position, :end_position

    def self.calculate_path_between(...)
      new(...).calculate_path_between
    end

    def initialize(board, start:, destination:)
      @start_position = start
      @end_position = destination
      @board = board
    end

    def calculate_path_between
      total_row_delta = end_position.row - start_position.row
      total_column_delta = end_position.column - start_position.column
      direction_vector = [
        convert_direction(total_row_delta),
        convert_direction(total_column_delta)
      ]
      steps = [total_row_delta.abs, total_column_delta.abs].max
      request_moves(direction_vector, steps)
    end

    private

    def convert_direction(delta)
      return 0 if delta.zero?

      delta.positive? ? 1 : -1
    end

    def request_moves(direction_vector, steps)
      calculator = MoveCalculator.new(start_position, piece)
      calculator.calculate_moves([direction_vector], steps)
    end

    def piece
      board.piece_at(start_position)
    end
  end
end
