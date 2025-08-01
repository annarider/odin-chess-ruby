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
    attr_reader :board

    def initialize(active_color: ChessNotation::WHITE_PLAYER,
                  board: Board.start_positions,
                  half_move_clock: 0,
                  full_move_number: 1)
      @active_color = active_color
      @board = board
      @half_move_clock = half_move_clock
      @full_move_number = full_move_number
    end

    def self.from_fen(fen_string)
      game_board = Board.from_fen(fen_string)
      game_data = FromFEN.to_game_data(fen_string)
      new(board: game_board, **game_data)
    end

    def to_fen
      ToFEN.create_fen
    end

    def start; end

    def current_player; end

    def play; end

    def play_turn; end

    def pick_column; end

    def end_game?(column); end

    def switch_turns; end

    private

    def create_fen_data
      {
        active_color: active_color,
        half_move_clock: half_move_clock,
        full_move_number: full_move_number
      }.merge(board_fen_data)
    end

    def board_fen_data
      board.to_fen
    end

    def create_players(players_data); end

    def handle_game_end(column, name)
      if board.winner?(column)
        announce_winner(name)
      else
        announce_end
      end
    end

    def announce_winner(name)
      puts "Game over! #{name} won."
    end

    def announce_end
      puts 'Game over! Nobody won.'
    end
  end
end
