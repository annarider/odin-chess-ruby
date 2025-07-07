require_relative '../lib/board'

# Terminal color configs
# Credit: Josh Smith
# https://dev.to/joshdevhub/terminal-colors-using-ruby-410p
module ColorizeString
  RGB_COLOR_MAP = {
    cyan: '139;233;253',
    green: '80;250;123',
    red: '255;85;85',
    cream: '240;217;181',
    coffee: '181;136;99',
    eggshell: '238;238;210',
    sage: '118;150;86',
    yellow: '255;206;84',
    amber: '209;139;71',
    gray: '232;235;239',
    slate: '35;65;75'
  }

  refine String do
    def color(color_name, ground: fore)
      rgb_value = RGB_COLOR_MAP[color_name]
      "\e[#{ground == 'fore' ? 38 : 48};2;#{rgb_value}m#{self}\e[0m"
    end
  end
end

class Display 
  using ColorizeString

  def display_board(board)
    puts 'New game: starting board'.color(:cyan, ground: 'fore')
    puts ' a b c d e f g h'.color(:green, ground: 'back')
    board.grid.each do |rank|
      puts '\033[47m' if rank.nil?
    end
    green_rgb = '0;128;0'
    puts "\e[38;2;#{green_rgb}mhello\e[0m world"

    format_board_display = board.grid.map do |rank|
      rank.map do |file|
        if file.nil?
          ' a '
        else
          ' ♟ '
        end
      end
    end

    format_board_display.each_with_index do |rank, rank_index|
      # rank.fg_color(:slate) if index.even?
      rank.map.with_index do |file, file_index|
        combined_indices = rank_index + file_index
        print format_checkered_color(combined_indices, file)
      end
      print "\n"
    end
  end

  def format_checkered_color(index, file)
    if index.even? # "white on the right"
      file.color(:gray, ground: 'back')
    else
      file.color(:slate, ground: 'back')
    end
  end
end

board = Chess::Board.new
display = Display.new
display.display_board(board)
