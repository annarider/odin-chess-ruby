# frozen_string_literal: true

module Chess
  # Tracks a Move object
  # to record important properties
  # about a move. This is useful
  # for building a move history
  # and later for calculating
  # threefold repetition.
  class Move
    attr_reader :from_position, :to_position, :piece, :captured_piece,
                :castling, :en_passant_target, :promotion, :double_pawn_move

    def initialize(
      from_position:,
      to_position:,
      piece:,
      captured_piece: nil,
      castling: nil,
      en_passant_target: nil,
      promotion: nil,
      double_pawn_move: nil
    )
      validate_position(from_position)
      validate_position(to_position)

      @from_position = from_position
      @to_position = to_position
      @piece = piece
      @captured_piece = captured_piece
      @castling = castling
      @en_passant_target = en_passant_target
      @promotion = promotion
      @double_pawn_move = double_pawn_move
    end

    private

    def validate_position(position)
      raise ArgumentError, "#{position} must be a Position object" unless position.is_a?(Chess::Position)

      raise ArgumentError, "#{position.coordinates} is out of bounds" unless position.in_bound?
    end
  end
end
