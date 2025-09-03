# frozen_string_literal: true

module Chess
  # GameController orchestrates the game flow and coordinates
  # between the Game domain object and external services
  # (Interface, Display, GameSerializer).
  # It handles the main game loop, user input processing,
  # and delegates domain operations to the Game object.
  #
  # @example Start a new game
  # game = Game.new
  # controller = GameController.new(game)
  # controller.play
  class GameController
    attr_reader :game

    def initialize(game = Game.new)
      @game = game
    end

    def play
      start_game
      game_loop
      announce_game_end
    end

    private

    def start_game
      Interface.welcome
      Display.show_board(game.board.to_display)
    end

    def game_loop
      until game.game_over?
        play_turn
        game.switch_turn unless game.game_over?
      end
    end

    def play_turn
      Interface.announce_turn(game.active_color)
      input = Interface.request_move
      
      case input[:action]
      when :quit
        handle_quit
      when :save
        handle_save
      when :load
        handle_load
      when :move
        handle_move(input[:from], input[:to])
      when :invalid
        Interface.announce_invalid_move
        play_turn
      end
    end

    def handle_quit
      puts "Thanks for playing!"
      exit
    end

    def handle_save
      puts "Save functionality not yet implemented."
      play_turn
    end

    def handle_load
      puts "Load functionality not yet implemented."
      play_turn
    end

    def handle_move(from, to)
      move = Move.new(from, to)
      
      if game.execute_move(move)
        Display.show_board(game.board.to_display)
      else
        Interface.announce_invalid_move
        play_turn
      end
    end

    def announce_game_end
      if game.winner
        announce_winner
      else
        announce_draw
      end
    end

    def announce_winner
      winner_name = game.winner == ChessNotation::WHITE_PLAYER ? 'White' : 'Black'
      puts "Checkmate! Game over. #{winner_name} won!"
    end

    def announce_draw
      puts "Game over. It's a draw."
    end
  end
end