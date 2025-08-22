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
    def self.promotion_legal?(...)
      new(...).promotion_legal?
    end

    def initialize(move)
      @end_position = move.to_position
      @piece = move.piece
    end

    def promotion_legal?
      
    end
  end
end
