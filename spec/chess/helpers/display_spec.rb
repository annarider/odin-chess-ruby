# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Connect Four Display class

describe Chess::Display do
  describe '#map_piece_symbol' do
    subject(:display) { described_class.new(mock_board_data) }

    let(:mock_board_data) { [%w[r n b q k b n r]] }

    context 'when taking the raw pieces data as input' do
      Chess::Piece::PIECE_SYMBOLS.map do |code, symbol|
        it "shows the piece #{code} maps to the #{symbol}" do
          expect(display.map_piece_symbol(code)).to eq(symbol)
        end
      end
    end
  end

  describe '#show_board' do
    context 'when starting a new game' do
      let(:mock_board_data) do
        [
          ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'],
          ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
          ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']
        ]
      end

      it 'DEBUG: shows the board visually', :debug do
        result = described_class.show_board(mock_board_data)
        puts "\nBoard State:\n#{result}\n" if RSpec.current_example.metadata[:debug]
        expect(result).to be_a(String)
      end

      it 'returns a string to print to the console' do
        result = described_class.show_board(mock_board_data)
        expect(result).to be_a(String)
      end

      it 'returns a string representation of the board' do
        white_king = '♔'
        white_knight = '♘'
        black_queen = '♛'
        black_pawn = '♟'
        result = described_class.show_board(mock_board_data)
        expect(result).to include(white_king).once
        expect(result).to include(white_knight).twice
        expect(result).to include(black_queen).once
        expect(result).to include(black_pawn).exactly(8).times
      end

      it 'returns the correct number of squares wide' do
        result = described_class.show_board(mock_board_data)
        expect(result.lines.count).to eq(Chess::Config::GRID_LENGTH)
      end
    end
  end
end
