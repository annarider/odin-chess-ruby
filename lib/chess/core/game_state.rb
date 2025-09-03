# frozen_string_literal: true

module Chess
  # Game represents the core chess game domain model.
  # It manages game state (board, active player, move history)
  # and enforces chess rules (checkmate, stalemate, draws).
  # Game flow orchestration is handled by GameController.
  #
  # @example Create a new Game
  # state = GameState.new
  class GameState
    attr_accessor :active_color, :half_move_clock,
                  :full_move_number
    attr_reader :board, :move_history

    def initialize(active_color: ChessNotation::WHITE_PLAYER,
                   board: Board.start_positions,
                   half_move_clock: 0,
                   full_move_number: 1,
                   move_history: MoveHistory.new)
      @active_color = active_color
      @board = board
      @half_move_clock = half_move_clock
      @full_move_number = full_move_number
      @move_history = move_history
      @game_over = false
    end

    def self.from_fen(fen_string)
      game_board = Board.from_fen(fen_string)
      game_data = FromFEN.to_game_data(fen_string)
      new(board: game_board, **game_data)
    end

    def to_fen
      ToFEN.create_fen(build_fen_data)
    end

    def play_move(move)
      return false unless MoveValidator.move_legal?(board, move, active_color)

      MoveCommander.execute_move(board, move)
      move_history.add_move(move)
      update_counters_after_move(move)
      switch_turn
      true
    end

    def switch_turn
      @active_color = PieceHelpers.opponent_color(active_color)
    end

    def game_over?
      @game_over || checkmate? || stalemate? || draw_by_rule?
    end

    def winner
      return nil unless game_over?
      return nil if stalemate? || draw_by_rule?

      PieceHelpers.opponent_color(active_color)
    end

    private

    def build_fen_data
      {
        active_color: active_color,
        half_move_clock: half_move_clock,
        full_move_number: full_move_number
      }.merge(board_fen_data)
    end

    def board_fen_data
      board.to_fen
    end

    def update_counters_after_move(move)
      if pawn_move_or_capture?(move)
        self.half_move_clock = 0
      else
        self.half_move_clock += 1
      end

      self.full_move_number += 1 if active_color == ChessNotation::BLACK_PLAYER
    end

    def checkmate?
      CheckmateDetector.checkmate?(board, active_color)
    end

    def stalemate?
      StalemateValidator.stalemate?(board, active_color)
    end

    def draw_by_rule?
      threefold_repetition? || fifty_move_rule? || insufficient_material?
    end

    def threefold_repetition?
      move_history.threefold_repetition?
    end

    def fifty_move_rule?
      half_move_clock >= 100
    end

    def insufficient_material?
      InsufficientMaterialDetector.insufficient_material?(board)
    end

    def pawn_move_or_capture?(move)
      piece = board.piece_at(move.from_position)
      piece&.type == :pawn || capture_move?(move)
    end

    def capture_move?(move)
      board.piece_at(move.to_position)
    end
  end
end
