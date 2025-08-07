# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Connect Four Chess::Interface module

describe Chess::Interface do
  describe '.request_players_data' do
    context 'when game greets the players' do
      it "requests and return the players' info" do
        allow(described_class).to receive(:gets).and_return('Anna', 'p', 'Alex', 'y')
        expect(described_class.request_players_data).to eq({ 'Anna' => 'p', 'Alex' => 'y' })
      end
    end
  end

  describe '.request_column' do
    context 'when the player chooses a move' do
      let(:valid_move) { '3' }

      before do
        allow(described_class).to receive(:gets).and_return(valid_column)
      end

      it 'returns the column number' do
        expect(described_class.request_column).to eq(3)
      end

      context 'when the chosen column is invalid twice then valid' do
        let(:letter) { 'd' }
        let(:symbol) { '$' }
        let(:valid_input) { '6' }

        before do
          allow(described_class).to receive(:gets).and_return(letter, symbol, valid_input)
          allow(described_class).to receive(:puts)
        end

        it 'completes loop after two incorrect tries' do
          described_class.request_column
          expect(described_class).to have_received(:puts).with(/Invalid/).twice
          expect(described_class.request_column).to eq(6)
        end
      end
    end
  end
end
