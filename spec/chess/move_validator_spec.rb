require_relative '../../lib/chess'

# Tests for module Move Validator
 
describe Chess::MoveValidator do
  let(:empty_board) { Board.default_grid }

  describe '#valid_move?' do
    context 'when move is valid' do
      let(:board) { double('board') }
      let(:move) do double('move',
        from_position: Chess::Position.from_algebraic('d5'),
        to_position: Chess::Position.from_algebraic('c3'), 
        piece: 'N')
      allow(board).to receive(:possible_moves)
      end

      it 'returns true' do
        expect(validator.valid_move?(board, move)).to be true
      end
    end
  end
end
