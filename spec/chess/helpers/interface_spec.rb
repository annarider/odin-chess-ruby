# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Connect Four Chess::Interface module

describe Chess::Interface do
  describe '.request_players_data' do
    context 'when game greets the players' do
      it "should request and return the players' info" do
        allow(Chess::Interface).to receive(:gets).and_return('Anna', 'p', 'Alex', 'y')
        expect(Chess::Interface.request_players_data).to eq({ 'Anna' => 'p', 'Alex' => 'y' })
      end
    end
  end
  describe '.request_column' do
    context 'when the player chooses a column to drop a piece into' do
      context 'when the chosen column is between 0 and 6' do
        let(:valid_column) { '3' }

        before do
          allow(Chess::Interface).to receive(:gets).and_return(valid_column)
        end
        it 'returns the column number' do
          expect(Chess::Interface.request_column).to eq(3)
        end
      end
      context 'when the chosen column is invalid twice then valid' do
        let(:letter) { 'd' }
        let(:symbol) { '$' }
        let(:valid_input) { '6' }

        before do
          allow(Chess::Interface).to receive(:gets).and_return(letter, symbol, valid_input)
          allow(Chess::Interface).to receive(:puts)
        end

        it 'completes loop after two incorrect tries' do
          Chess::Interface.request_column
          expect(Chess::Interface).to have_received(:puts).with(/Invalid/).twice
          expect(Chess::Interface.request_column).to eq(6)
        end
      end
    end
  end
end
