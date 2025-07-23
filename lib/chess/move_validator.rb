# frozen_string_literal: true

module Chess
  # Move Validator performs checks
  # to ensure the move is valid
  # before allow the move to
  # persist and update the board/
  # game state.
  #
  # Move Validator may call upon
  # helper modules to perform
  # specialty validations, such as
  # check.
  class MoveValidator
    attr_reader :board, :move

    def initialize(board, move)
      @board = board
      @move = move
    end

    def is_move_legal?
      return false unless possible_move?
      return false unless capture_enemy_piece?
      # return false unless castling_available?
      # return false unless en_passant_allowed?
      # return false unless legal_pawn_moves? # (en passant, promotion, capture)
      # return false unless leave_king_in_check?

      true
    end

    private

    def possible_move?
      all_moves = board.possible_moves(move.from_position)
      all_moves.include?(move.to_position)
    end

    def capture_enemy_piece?
      return false unless attempted_attack? # no capture happened

      attack_piece = move.piece
      target_piece = board.piece_at(move.to_position)
      enemy_color?(attack_piece, target_piece)
    end

    def attempted_attack?
      target_piece = board.piece_at(move.to_position)
      return false if target_piece.nil? # no piece at target position

      true
    end

    def enemy_color?(attack_piece, captured_piece)
      (attack_piece.upcase && captured_piece.downcase) ||
      (attack_piece.downcase && captured_piece.upcase )
    end
  end
end
