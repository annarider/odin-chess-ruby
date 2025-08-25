# frozen_string_literal: true

module Chess
  # Promotion Validator checks
  # if a pawn should be promoted
  # when it reaches the last rank
  # for its color.
  #
  # It doesn't tell Board to update
  # itself. Move Commander will
  # instruct Board to update itself.
  class PromotionValidator
    attr_reader :end_position, :piece

    def self.promotion_legal?(...)
      new(...).promotion_legal?
    end

    def initialize(move)
      @end_position = move.to_position
      @piece = move.piece
    end

    def promotion_legal?
      return false unless end_position
      return false unless Piece::PAWN_PIECES.include?(piece)
      return false unless pawn_reached_last_rank?

      true
    end

    private

    def pawn_reached_last_rank?
      if piece == 'P'
        # white pawns start on rank 2, last rank is 8
        end_position.rank == '8'
      elsif piece == 'p'
        # black pawns start on rank 7, last rank is 1
        end_position.rank == '1'
      else
        false
      end
    end
  end
end
