# frozen_string_literal: true

require 'digest/md5'

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
      add_to_position(move.fen)
    end

    def count_moves
      move_history.count
    end

    def threefold_repetition?
      return true if count_duplicate_positions.values.any? { |count| count >= 3 }

      false
    end

    def add_to_position(fen_string)
      position = fen_position(fen_string)
      @past_positions << hash_position(position) if position
    end

    def has_moved?(starting_position)
      move_history.any? { |move| move.from_position == starting_position }
    end

    private

    def hash_position(partial_fen_string)
      Digest::MD5.hexdigest(partial_fen_string)
    end

    def count_duplicate_positions
      return nil if past_positions.nil?

      count = Hash.new(0)
      past_positions.each { |position| count[position] += 1 }
      count
    end

    def fen_position(fen_string)
      parse_fen_for_positions(fen_string)
    end
  end
end
