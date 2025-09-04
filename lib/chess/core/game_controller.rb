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
    attr_reader :state

    def initialize(state = GameState.new)
      @state = state
    end

    def play
      start_game
      game_loop
      announce_game_end
    end

    private

    def start_game
      Interface.welcome
      Display.show_board(state.board.to_display)
    end

    def game_loop
      until state.game_over?
        play_turn
        state.switch_turn unless state.game_over?
      end
    end

    def play_turn
      Interface.announce_turn(state.active_color)
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
      if Interface.confirm_quit
        puts 'Thanks for playing!'
        exit
      else
        play_turn
      end
    end

    def handle_save
      filename = Interface.request_save_filename
      result = GameSerializer.save_game(state, filename)
      if result[:success]
        puts "Game saved successfully as '#{result[:filename]}.json'"
      else
        puts "Failed to save game: #{result[:error]}"
      end
      play_turn
    end

    def handle_load
      filename = Interface.request_load_filename
      return play_turn if filename.empty?

      result = GameSerializer.load_game(filename)
      if result[:success]
        @state = result[:state]
        puts "Game loaded successfully from '#{result[:filename]}.json'"
        Display.show_board(state.board.to_display)
      else
        puts "Failed to load game: #{result[:error]}"
      end
      play_turn
    end

    def handle_move(from, to)
      piece = state.board.piece_at(from)
      move = Move.new(from_position: from, to_position: to, piece: piece,
                      fen: state.to_fen)
      if state.play_move(move)
        Display.show_board(state.board.to_display)
      else
        Interface.announce_invalid_move
        play_turn
      end
    end

    def announce_game_end
      if state.winner
        announce_winner
      else
        announce_draw
      end
    end

    def announce_winner
      winner_name = state.winner == ChessNotation::WHITE_PLAYER ? 'White' : 'Black'
      puts "Checkmate! Game over. #{winner_name} won!"
    end

    def announce_draw
      puts "Game over. It's a draw."
    end
  end
end
