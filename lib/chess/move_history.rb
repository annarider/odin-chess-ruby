# frozen_string_literal: true

module Chess
  class MoveHistory
    include FromFEN
    attr_accessor :move_history, :past_positions

    def initialize(move_history = [], past_positions = [])
      @move_history = move_history
      @past_positions = past_positions
    end

    def add_move(move)
      @move_history << move
      @past_positions << fen_position(move.fen) if fen_position(move.fen)
    end

    def move_count
      move_history.count
    end

    def threefold_repetition?
      return true if count_past_positions.values.any? { |count| count >= 3 }

      false
    end

    private

    def count_past_positions
      count = {}
      past_positions.each { |position| count[position] += 1 }
      count
    end

    def fen_position(fen_string)
      parse_fen_for_positions(fen_string)
    end
  end
end
