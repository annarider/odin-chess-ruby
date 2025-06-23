# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/display'

# Tests for the Connect Four Display class

describe Chess::Display do
  describe '#map_piece_symbol' do
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
  describe '#build_board_for_display' do
    context 'when starting a new game' do
      let(:new_board_double) { instance_double('board') }
      subject(:display) { described_class.new(new_board_double) }

      before do
        white_king = '♔'
        white_knight = '♘'
        black_queen = '♛'
        black_pawn = '♟'
        allow(new_board_double).to receive(:puts)
          .and_return(white_king, white_knight, black_queen, black_pawn)
      end
      it 'displays the game board with all pieces in correct positions' do
        result = display.show_board
        expect(result).to include(white_king)
        expect(result).to include(white_knight)
        expect(result).to include(black_queen)
        expect(result).to include(black_pawn)
      end
    end
  end
end
