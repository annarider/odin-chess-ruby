# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for the Move class

describe Chess::Move do
  let(:valid_from_position) { Chess::Position.from_algebraic('b2') }
  let(:valid_to_position) { Chess::Position.from_algebraic('b4') }

  describe '#initialize' do
    context 'when creating from valid positions' do
      it 'creates a move successfully' do
        expect {
          described_class.new(
            from_position: valid_from_position,
            to_position: valid_to_position,
            piece: 'P',
            captured_piece: 'p',
            double_pawn_move: true
          )
      }.not_to raise_error
      end
      context 'when given invalid positions' do
        let(:invalid_position) { double('invalid_position') }
        before do
          allow(invalid_position).to receive(:is_a?)
            .with(Chess::Position).and_return(false)
        end
        it 'raises an ArgumentError' do
          expect {
            described_class.new(
              from_position: invalid_position,
              to_position: valid_to_position,
              piece: 'p',
            )
        }.to raise_error(ArgumentError, /must be a Position object/)
        end
      end
      context 'when given an out of bounds object' do
        let(:out_of_bounds_position) { double('out_of_bounds_position') }
        before do
          allow(out_of_bounds_position).to receive(:is_a?)
            .with(Chess::Position).and_return(true)
          allow(out_of_bounds_position).to receive(:in_bound?).and_return(false)
          allow(out_of_bounds_position).to receive(:coordinates).and_return([9 ,9])
        end
        it 'raises ArgumentError for out-of-bounds from_position' do
          expect {
            described_class.new(
              from_position: out_of_bounds_position,
              to_position: valid_to_position,
              piece: 'R'
            )
        }.to raise_error(ArgumentError, /is out of bounds/)
        end
      end
    end
  end
end
