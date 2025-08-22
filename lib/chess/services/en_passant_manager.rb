module Chess
  # En Passant Manager validates
  # en passant moves.
  #
  # It also requests Board to
  # make piece position updates
  # if the en passant move is
  # considered valid.
  class EnPassantManager
    PAWN_PIECES = %w[p P].freeze
    attr_reader :piece, :start_position, :end_position, :en_passant_target,
    :double_pawn_move, :opponent_last_move

    def self.en_passant_legal?(...)
      new(...).en_passant_legal?
    end

    def initialize(move, en_passant_target)
      @piece = move.piece
      @start_position = move.from_position
      @end_position = move.to_position
      @en_passant_target = en_passant_target
      @double_pawn_move = move.double_pawn_move
      @opponent_last_move = move.opponent_last_move
    end

    def en_passant_legal?
      return false unless PAWN_PIECES.include?(piece)
      return false if double_pawn_move
      return false unless end_position_matches_target?
      return false unless opponent_last_move_double_pawn_advance?

      true
    end

    private

    def end_position_matches_target?
      return false unless en_passant_target

      end_position == en_passant_target
    end

    def opponent_last_move_double_pawn_advance?
      return false unless opponent_last_move
      return false unless opponent_last_move.double_pawn_move

      # The pawn that made the double move should now be adjacent to our pawn
      opponent_last_move.to_position.adjacent?(start_position)
    end
  end
end
