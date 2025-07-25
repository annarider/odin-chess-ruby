module Chess
  class MoveHistory
    attr_accessor :move_history, :position_hash

    def initialize(move_history = [], position_hash = {})
      @move_history = move_history
      @position_hash = position_hash
    end

    def add_move(move)
      @move_history << move
    end
  end
end
