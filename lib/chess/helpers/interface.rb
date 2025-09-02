# frozen_string_literal: true

# Interface defines a game IO
# in Chess.
#
# It displays messages to the
# user and receives input for
# game play. It also verifies
# and cleanses user input.
#
module Chess
  module Interface
    def self.welcome
      puts <<~WELCOME
        ♔♟️ Welcome to Chess. You will play a Chess game in the console.
        We will have 2 players represented by color, white and black.
        As with traditional chess games, white moves first.
      WELCOME
    end

    def self.request_move
      puts "Enter your move (e.g., 'e2 e4' or 'e2-e4'), or type 'quit', 'save', or 'load':"
      input = gets.chomp.strip

      case input.downcase
      when 'quit', 'q'
        { action: :quit }
      when 'save', 's'
        { action: :save }
      when 'load', 'l'
        { action: :load }
      else
        move_data = parse_move_input(input)
        move_data ? { action: :move, **move_data } : { action: :invalid }
      end
    end

    def self.announce_turn(color)
      color_name = color == ChessNotation::WHITE_PLAYER ? 'White' : 'Black'
      puts "#{color_name}'s turn."
    end

    def self.announce_check(color)
      color_name = color == ChessNotation::WHITE_PLAYER ? 'White' : 'Black'
      puts "#{color_name} is in check!"
    end

    def self.announce_invalid_move
      puts '❌ Invalid move. Please try again.'
    end

    def self.request_save_filename
      puts 'Enter filename to save (without extension):'
      filename = gets.chomp.strip
      filename.empty? ? "chess_game_#{Time.now.strftime('%Y%m%d_%H%M%S')}" : filename
    end

    def self.request_load_filename
      puts 'Enter filename to load (without extension):'
      gets.chomp.strip
    end

    def self.confirm_quit
      puts 'Are you sure you want to quit? (y/n)'
      response = gets.chomp.downcase
      %w[y yes].include?(response)
    end

    class << self
      private

      def parse_move_input(input)
        normalized = input.downcase.gsub(/[\s\-]/, ' ').strip
        parts = normalized.split

        return nil unless parts.length == 2
        return nil unless valid_square?(parts[0]) && valid_square?(parts[1])

        {
          from: Position.from_algebraic(parts[0]),
          to: Position.from_algebraic(parts[1]),
          raw_input: input
        }
      end

      def valid_square?(square)
        return false unless square.length == 2
        return false unless square[0].between?('a', 'h')
        return false unless square[1].between?('1', '8')

        position = Position.from_algebraic(square)
        position.in_bound?
      end
    end
  end
end
