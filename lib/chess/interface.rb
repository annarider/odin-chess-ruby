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

    def self.show(grid)
      grid.each do |row|
        puts "| #{row.map { |cell| cell.nil? ? '  ' : map_color(cell) }.join(' ')} |"
      end
    end

    def self.announce_turn(name)
      puts "#{name}, it's your turn."
    end

    def self.request_column
      puts <<~MESSAGE
        🔮 Which column do you want drop a piece into?
      MESSAGE
      column = gets.chomp.delete(' ').to_i
      valid_column?(column) ? column : request_column_again
    end

    def self.display_invalid_column_message
      puts '❌ Invalid column number. Please pick again.'
    end

    def self.request_name
      puts "What's your name?"
      gets.chomp
    end

    def self.valid_column?(input)
      input.between?(1, 7)
    end

    def self.request_symbol
      puts 'What color do you want? 🔴 🔵 🟡 🟣'
      puts "Type #{COLORS.split.join('  ')}"
      symbol = gets.chomp.delete(' ')
      valid_color?(symbol) ? symbol : request_color_again
    end

    def self.valid_color?(symbol)
      return false unless symbol.length == 1

      COLORS.include?(symbol)
    end

    def self.map_color(symbol)
      case symbol
      when 'r'
        '🔴'
      when 'b'
        '🔵'
      when 'y'
        '🟡'
      else
        '🟣'
      end
    end

    def self.request_color_again
      puts '❌ Invalid symbol color.'
      request_symbol
    end
  end
end
