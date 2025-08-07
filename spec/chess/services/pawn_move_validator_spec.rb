# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for Pawn Move Validator

describe Chess::PawnMoveValidator do
  describe '.valid_move?' do
    let(:move) { instance_double(Chess::Move) }
    let(:move_history) { instance_double(Chess::MoveHistory) }
    let(:start_position) { double('start_position') }
    let(:end_position) { double('end_position') }
    
    before do
      allow(move).to receive(:from_position).and_return(start_position)
      allow(move).to receive(:to_position).and_return(end_position)
      allow(move).to receive(:piece).and_return('P')
      allow(move).to receive(:captured_piece).and_return(nil)
    end
    context 'when white pawn advances 1 square' do
      before do
        allow(start_position).to receive(:diagonal_move?).with(end_position).and_return(false)
        allow(start_position).to receive(:two_rank_move?).with(end_position).and_return(false)
      end
        it 'returns true' do
          result = described_class.valid_move?(move, move_history)
          expect(result).to be true
        end
    end
  end
end
