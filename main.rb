# frozen_string_literal: true

# main contains the main execution
# for running a Chess game

require_relative 'lib/game'

loop do
  game = Game.new
  game.start
  game.play
  puts 'Play again? Enter y for yes (y): '
  break unless gets.chomp.downcase == 'y'
end
