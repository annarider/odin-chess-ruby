# frozen_string_literal: true

require_relative '../chess'

module Chess
  # Game defines a game object
  # which handles game logic.
  # It orchestrates creating board
  # objects, switching player
  # turns, checking for game over
  # and win conditions, etc.
  #
  # @example Create a new Game
  # game = Game.new
  class Game
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

    def play
      start
      until game_over?
        play_turn
        switch_turn unless game_over?
      end
      announce_game_end
    end

    def start
      Interface.welcome
      Display.show_board(board.to_display)
    end

    def play_turn; end

    def pick_column; end

    def end_game?(column); end

    def switch_turn
      @active_color = active_color == 'w' ? 'b' : 'w'
    end

    def game_over?
      @game_over || checkmate? || stalemate? || draw_by_rule?
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

    def checkmate?
      false
    end

    def stalemate?
      false
    end

    def draw_by_rule?
      threefold_repetition? || fifty_move_rule?
    end

    def threefold_repetition?
      move_history.threefold_repetition?
    end

    def fifty_move_rule?
      half_move_clock >= 100
    end

    def announce_game_end
      if winner?
        announce_winner
      else
        announce_end
      end
    end

    def announce_winner
      puts "Checkmate! Game over. #{winner == 'w' ? 'White' : 'Black'} won!"
    end

    def announce_end
      puts "Game over. It's a draw."
    end
  end
end
