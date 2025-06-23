# frozen_string_literal: true

require_relative '../lib/display'

# Tests for the Connect Four Display class

describe Chess::Display do
  describe '.map_pieces_symbols' do
    context 'when taking the raw pieces data as input' do
      it 'shows the correct pictorial representation as output' do
        piece = 'BR'
        result = Chess::Display.map_pieces_symbols(piece)
        expect(result).to eq('♜')
      end
    end
  end
end
