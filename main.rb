# frozen_string_literal: true

require_relative 'lib/chess'

module Chess
  # main contains the main execution
  # for running a Chess game
  loop do
    game = Game.new
    game.play
    puts 'Play again? Enter y for yes (y): '
    break unless gets.chomp.downcase == 'y'
  end
end
