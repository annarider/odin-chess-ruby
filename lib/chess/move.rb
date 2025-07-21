# frozen_string_literal: true

module Chess
  # Tracks a Move object
  # to record important properties
  # about a move. This is useful
  # for building a move history
  # and later for calculating
  # threefold repetition.
  class Move
    include Chess::MoveCalculator
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
      @from_position = from_position
      @to_position = to_position
      @piece = piece
      @captured_piece = captured_piece
      @castling = castling
      @en_passant_target = en_passant_target
      @promotion = promotion
      @double_pawn_move = double_pawn_move
    end

    def possible_moves
      generate_possible_moves(from_position, piece)
    end
  end
end
