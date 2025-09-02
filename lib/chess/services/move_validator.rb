# frozen_string_literal: true

module Chess
  # Move Validator performs checks
  # to ensure the move is valid
  # before allow the move to
  # persist and update the board/
  # game state.
  #
  # Move Validator may call upon
  # helper classes to perform
  # specialty validations, such as
  # check.
  class MoveValidator
    attr_reader :board, :move, :start_position, :end_position, :piece,
                :move_history

    def self.move_legal?(...)
      new(...).move_legal?
    end

    # def self.two_square_pawn_move?()
    def initialize(board, move, move_history = MoveHistory.new)
      @board = board
      @move = move
      @start_position = move.from_position
      @end_position = move.to_position
      @piece = move.piece
      @move_history = move_history
    end

    def move_legal?
      return false unless possible_move?
      return false unless valid_destination?
      return false unless clear_path?
      return false unless valid_piece_moves?
      return validate_castling if Piece::KING_PIECES.include?(piece) && castling_move?

      true
    end

    private

    def possible_move?
      all_moves = MoveCalculator.generate_possible_moves(start_position, piece)
      all_moves.include?(end_position)
    end

    def valid_destination?
      target_piece = board.piece_at(end_position)

      if target_piece.nil? # empty square
        true
      else
        PieceHelpers.opponent_color?(attack_piece: piece, captured_piece: target_piece)
      end
    end

    def clear_path?
      return true if %w[n N].include?(piece)

      path = PathCalculator.calculate_path_between(
        start: start_position,
        destination: end_position
      )
      # are there any pieces along the piece's movement path?
      path.all? { |position| board.piece_at(position).nil? }
    end

    def valid_piece_moves?
      return PawnMoveValidator.valid_move?(board, move) if Piece::PAWN_PIECES.include?(piece)

      # other pieces return true as they don't have piece-specific moves
      true
    end

    def castling_move?
      # Castling is when king moves 2 squares horizontally
      return false unless Piece::KING_PIECES.include?(piece)
      return false unless king_on_starting_rank?

      horizontal_distance = (end_position.column - start_position.column).abs
      vertical_distance = (end_position.row - start_position.row).abs

      horizontal_distance == 2 && vertical_distance.zero?
    end

    def king_on_starting_rank?
      if piece == 'K'
        # white king starts on rank 1
        start_position.rank == '1'
      elsif piece == 'k'
        # black king starts on rank 8
        start_position.rank == '8'
      else
        false
      end
    end

    def validate_castling
      CastlingValidator.castling_legal?(
        board,
        move,
        move_history
      )
    end
  end
end
