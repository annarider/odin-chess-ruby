module Chess
  # Move Calculator generates the 
  # possible moves each piece can
  # make. 
  # 
  # It does NOT validate
  # the moves. Validation happens
  # in Move Validator with the help
  # of specialty validation modules.
  # 
  # It does NOT make the moves. 
  module MoveCalculator
    def generate_possible_moves(position, piece)
      moves = []
      # move direction of pawn depends on color
      return pawn_moves(pawn) if piece == 'p' || piece == 'P'

      case piece.downcase
      when 'k'
        king_moves(position)
      when 'q'
        queen_moves(position)
      when 'b'
        bishop_moves(position)
      when 'n'
        knight_moves(position)
      when 'r'
        rook_moves(position)
      else
        []
      end
    end

    private

    def knight_moves(position)
      Chess::Directions::KNIGHT.map do |vector|
        position + Chess::Position.from_directional_vector(vector)
      end.compact
    end
  end
end
