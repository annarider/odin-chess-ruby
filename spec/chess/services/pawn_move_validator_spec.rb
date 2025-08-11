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
      allow(move).to receive_messages(from_position: start_position, to_position: end_position, piece: 'P',
                                      captured_piece: nil)
      allow(Chess::PieceHelpers).to receive(:enemy_color?)
      allow(move_history).to receive(:has_moved?)
    end

    context 'when white pawn advances 1 rank to an empty square' do
      before do
        allow(start_position).to receive(:diagonal_move?)
          .with(end_position).and_return(false)
        allow(start_position).to receive(:two_rank_move?)
          .with(end_position).and_return(false)
      end

      it 'returns true' do
        result = described_class.valid_move?(move, move_history)
        expect(result).to be true
      end
    end

    context 'when white pawn advances 2 ranks to an empty square' do
      before do
        allow(start_position).to receive(:diagonal_move?)
          .with(end_position).and_return(false)
        allow(start_position).to receive(:two_rank_move?)
          .with(end_position).and_return(true)
        allow(move_history).to receive(:has_moved?)
          .with(start_position).and_return(false)
      end

      it 'returns true when pawn has not moved' do
        result = described_class.valid_move?(move, move_history)
        expect(result).to be true
      end
    end

    context 'when white pawn advances 2 ranks to an empty square' do
      before do
        allow(start_position).to receive(:diagonal_move?)
          .with(end_position).and_return(false)
        allow(start_position).to receive(:two_rank_move?)
          .with(end_position).and_return(true)
        allow(move_history).to receive(:has_moved?)
          .with(start_position).and_return(true)
      end

      it 'returns false when pawn has moved' do
        result = described_class.valid_move?(move, move_history)
        expect(result).to be false
      end
    end

    context 'when white pawn moves diagonally to capture' do
      before do
        allow(start_position).to receive(:diagonal_move?)
          .with(end_position).and_return(true)
        allow(move).to receive(:captured_piece).and_return('b')
      end

      context 'when capturing an enemy piece' do
        it 'returns true' do
          expect(Chess::PieceHelpers).to receive(:enemy_color?)
            .with('P', 'b').and_return(true)
          result = described_class.valid_move?(move, move_history)
          expect(result).to be true
        end
      end

      context 'when trying to capture a friendly piece' do
        it 'returns false' do
          expect(Chess::PieceHelpers).to receive(:enemy_color?)
            .with('P', 'b').and_return(false)
          result = described_class.valid_move?(move, move_history)
          expect(result).to be false
        end
      end
    end

    context 'when white pawn moves diagonally to an empty square' do
      before do
        allow(start_position).to receive(:diagonal_move?)
          .with(end_position).and_return(true)
        allow(start_position).to receive(:captured_piece).and_return(nil)
      end

      it 'returns false' do
        result = described_class.valid_move?(move, move_history)
        expect(result).to be false
      end
    end
  end
end
