module Chess
  # En Passant Manager validates
  # en passant moves.
  #
  # It also requests Board to
  # make piece position updates
  # if the en passant move is
  # considered valid.
  class EnPassantManager
    attr_reader :piece, :end_position, :en_passant_target, :double_pawn_move,
      :opponent_last_move

    def self.en_passant_legal?(...)
      new(...).en_passant_legal?
    end

    def initialize(move)
      @piece = move.piece
      @end_position = move.to_position
      @en_passant_target = move.en_passant_target
      @double_pawn_move = move.double_pawn_move
      @opponent_last_move = move.opponent_last_move
    end

    def en_passant_legal?
      return false unless %w[p P].include?(piece)
      return false if double_pawn_move
      return false unless end_position == en_passant_target
      return false unless opponent_last_move_double_pawn_advance?
      return false unless adjacent_pawn_positions?

      true
    end

    private

    def opponent_last_move_double_pawn_advance?
      return false unless opponent_last_move

      opponent_last_move.double_pawn_move &&
        opponent_last_move.to_position == captured_pawn_end_position
    end

    def captured_pawn_end_position
      directional_vector = if piece == 'K'
                              Directions::PAWN_WHITE.first
                           else
                              Directions::PAWN_BLACK.first
                           end
      en_passant_target + directional_vector
    end
  end
end
