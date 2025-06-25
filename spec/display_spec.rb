# frozen_string_literal: true

require_relative '../lib/chess'

# Tests for the Connect Four Display class

describe Chess::Display do
  let(:new_board_double) { instance_double('board') }
  subject(:display) { described_class.new(new_board_double) }
  describe '#map_piece_symbol' do
    context 'when taking the raw pieces data as input' do
      Chess::Config::PIECE_SYMBOLS.map do |code, symbol|
        it "shows the piece #{code} maps to the #{symbol}" do
          expect(display.map_piece_symbol(code)).to eq(symbol)
        end
      end
    end
  end
  describe '#build_board_for_display' do
    context 'when starting a new game' do
      before do
        mock_board_data = [
          ['BR', 'BN', 'BB', 'BQ', 'BK', 'BB', 'BN', 'BK'],
          ['BP', 'BP', 'BP', 'BP', 'BP', 'BP', 'BP', 'BP'],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['WP', 'WP', 'WP', 'WP', 'WP', 'WP', 'WP', 'WP'],
          ['WR', 'WN', 'WB', 'WQ', 'WK', 'WB', 'WN', 'WR']
        ]
        allow(new_board_double).to receive(:extract_grid_and_pieces).and_return(mock_board_data)
      end
      it 'DEBUG: shows the board visually', :debug do
        result = display.build_board_for_display
        puts "\nBoard State:\n#{result}\n" if RSpec.current_example.metadata[:debug]
        expect(result).to be_a(String)
      end

      it 'returns a string representation of the board' do
        white_king = '♔'
        white_knight = '♘'
        black_queen = '♛'
        black_pawn = '♟'
        result = display.build_board_for_display
        expect(result).to be_a(String)
        expect(result.lines.count).to eq(Chess::Config::GRID_LENGTH)
        expect(result).to include(white_king).once
        expect(result).to include(white_knight).twice
        expect(result).to include(black_queen).once
        expect(result).to include(black_pawn).exactly(8).times
      end
    end
  end
end
