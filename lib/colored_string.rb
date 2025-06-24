# frozen_string_literal: true

# ColoredString configures Terminal
# output color settings
# Credit: Josh Smith
# https://dev.to/joshdevhub/terminal-colors-using-ruby-410p
module Chess
  module ColoredString
    refine String do
      def output_color(color_name, ground: fore)
        rgb_value = Chess::Config::RGB_COLOR_MAP[color_name]
        "\e[#{ground == 'fore' ? 38 : 48};2;#{rgb_value}m#{self}\e[0m"
      end
    end
  end
end
