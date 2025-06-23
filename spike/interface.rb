require_relative '../lib/board'

# Terminal color configs
# Credit: Josh Smith
# https://dev.to/joshdevhub/terminal-colors-using-ruby-410p
module ColoredString
  RGB_COLOR_MAP = {
    cyan: '139;233;253',
    green: '80;250;123',
    red: '255;85;85'
  }

  refine String do
    def fg_color(color_name)
      rgb_value = RGB_COLOR_MAP[color_name]
      "\e[38;2;#{rgb_value}m#{self}\e[0m"
    end
  end
end

class display
  def display_board(board)
    puts 'New game: starting board'
    puts ' a b c d e f g h'
    board.grid.each do |rank|
      puts '\033[47m' if rank.nil?
    end
    green_rgb = "0;128;0"
    puts "\e[38;2;#{green_rgb}mhello\e[0m world"
  
  
  end  
end

board = Chess::Board.new
display_board(board)
