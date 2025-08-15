require_relative '../../../lib/chess'

# Tests for Check Detector

describe Chess::CheckDetector do
  subject(:detector) { described_class }

  let(:board) { Chess::Board.new }

  describe '.in_check?' do
    context 'when starting a new game and king is not in check' do
      it 'returns false for white king' do
        expect(detector.in_check?(board, :white)).to be false
      end
    end
  end
end
