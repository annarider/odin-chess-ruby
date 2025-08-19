module Chess
  # Find all the squares between start and destination positions
  class PathCalculator
    attr_reader :start_position, :end_position

    def self.calculate_path_between(...)
      new(...).calculate_path
    end

    def initialize(start:, destination:)
      @start_position = start
      @end_position = destination
    end

    def calculate_path
      return [] if same_position? || adjacent_positions?
      return [] unless valid_line?

      build_path
    end

    private

    def same_position?
      start_position == end_position
    end

    def adjacent_positions?
      row_distance <= 1 && column_distance <= 1
    end

    def valid_line?
      horizontal_line? || vertical_line? || diagonal_line?
    end

    def horizontal_line?
      start_position.row == end_position.row
    end

    def vertical_line?
      start_position.column == end_position.column
    end

    def diagonal_line?
      row_distance == column_distance
    end

    def build_path
      positions = []
      current_position = start_position + direction_vector

      while current_position != end_position
        positions << current_position
        current_position += direction_vector
      end

      positions
    end

    def direction_vector
      Position.new(
        normalize_direction(end_position.row - start_position.row),
        normalize_direction(end_position.column - start_position.column)
      )
    end

    def normalize_direction(delta)
      return 0 if delta.zero?

      delta.positive? ? 1 : -1
    end

    def request_moves(direction_vector, steps)
      calculator = MoveCalculator.new(start_position, piece)
      calculator.calculate_moves([direction_vector], steps)
    end

    def row_distance
      (start_position.row - end_position.row).abs
    end

    def column_distance
      (start_position.column - end_position.column).abs
    end
  end
end
