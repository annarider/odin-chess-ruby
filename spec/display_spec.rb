# frozen_string_literal: true

require_relative '../lib/display'

# Tests for the Connect Four Display class

describe Chess::Display do
  describe '.map_piece_symbol' do
    context 'when taking the raw pieces data as input' do
      pieces_map = {
        'WK' => '♔', 'BK' => '♚',
        'WQ' => '♕', 'BQ' => '♛',
        'WR' => '♖', 'BR' => '♜',
        'WB' => '♗', 'BB' => '♝',
        'WN' => '♘', 'BN' => '♞',
        'WP' => '♙', 'BP' => '♟'
      }
      pieces_map.map do |code, symbol| 
        it "shows the piece #{code} maps to the #{symbol}" do
          expect(Chess::Display.map_piece_symbol(code)).to eq(symbol)
        end
      end
    end
  end
end
