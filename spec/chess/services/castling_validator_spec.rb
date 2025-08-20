# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for Castling class

describe Chess::CastlingValidator do
  subject(:validator) { described_class }
  let(:board) { Chess::Board.start_positions(add_pieces: true) }
  let(:move_history) { Chess::MoveHistory.new }

  # Helper methods to create real Position and Move objects
  def position(square)
    Chess::Position.from_algebraic(square)
  end

  def create_castling_move(from_square, to_square, piece, rook_square)
    Chess::Move.new(
      from_position: position(from_square),
      to_position: position(to_square),
      piece: piece,
      castling: position(rook_square)
    )
  end

  def create_regular_move(from_square, to_square, piece)
    Chess::Move.new(
      from_position: position(from_square),
      to_position: position(to_square),
      piece: piece
    )
  end

  describe '.castling_legal?' do
    # Test the happy path - when all castling conditions are met
    context 'when all castling conditions are met' do
      it 'returns true for valid white kingside castling' do
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        result = validator.castling_legal?(move, board, move_history)
        expect(result).to be true
      end

      it 'returns true for valid white queenside castling' do
        move = create_castling_move('e1', 'c1', 'K', 'a1')
        result = validator.castling_legal?(move, board, move_history)
        expect(result).to be true
      end

      it 'returns true for valid black kingside castling' do
        move = create_castling_move('e8', 'g8', 'k', 'h8')
        result = validator.castling_legal?(move, board, move_history)
        expect(result).to be true
      end

      it 'returns true for valid black queenside castling' do
        move = create_castling_move('e8', 'c8', 'k', 'a8')
        result = validator.castling_legal?(move, board, move_history)
        expect(result).to be true
      end
    end

    context 'when the king has previously moved' do
      let(:move_history_with_king_move) do
        history = Chess::MoveHistory.new
        king_move = create_regular_move('e1', 'e2', 'K')
        history.add_move(king_move)
        history
      end
      it 'returns false' do
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        result = validator.castling_legal?(move, board, move_history)
        expect(result).to be false
      end
    end

    context 'when the rook has previously moved' do
      let(:move_history_with_rook_move) do
        history = Chess::MoveHistory.new
        rook_move = create_regular_move('h1', 'h2', 'R')
        history.add_move(rook_move)
        history
      end
      it 'returns false' do
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        result = validator.castling_legal?(move, board, move_history)
        expect(result).to be false
      end
    end

    context 'when the king is currently in check' do
      it 'returns false' do
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        result = validator.castling_legal?(move, board, move_history)
        expect(result).to be false
      end
    end

    context 'when the castling path is under attack' do
      before do
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER)
          .and_return(false)
        # Path square f1 is under attack
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER, position('f1'))
          .and_return(true)
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER, position('g1'))
          .and_return(false)
        allow(path_calculator).to receive(:calculate_path_between)
          .with(position('e1'), position('g1'))
          .and_return([position('f1')])
      end

      it 'returns false' do
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        
        result = validator.castling_legal?(
          move,
          board,
          move_history,
          check_detector: check_detector,
          path_calculator: path_calculator
        )
        
        expect(result).to be false
      end
    end

    context 'when castling would put the king in check' do
      before do
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER)
          .and_return(false)
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER, position('f1'))
          .and_return(false)
        # King would be in check at destination
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER, position('g1'))
          .and_return(true)
        allow(path_calculator).to receive(:calculate_path_between)
          .with(position('e1'), position('g1'))
          .and_return([position('f1')])
      end

      it 'returns false' do
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        
        result = validator.castling_legal?(
          move,
          board,
          move_history,
          check_detector: check_detector,
          path_calculator: path_calculator
        )
        
        expect(result).to be false
      end
    end

    context 'with queenside castling and multiple path squares' do
      before do
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER)
          .and_return(false)
        # d1 square is attacked, b1 is safe
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER, position('d1'))
          .and_return(true)
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER, position('b1'))
          .and_return(false)
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER, position('c1'))
          .and_return(false)
        allow(path_calculator).to receive(:calculate_path_between)
          .with(position('e1'), position('c1'))
          .and_return([position('d1'), position('b1')])
      end

      it 'returns false when any path square is attacked' do
        move = create_castling_move('e1', 'c1', 'K', 'a1')
        
        result = validator.castling_legal?(
          move,
          board,
          move_history,
          check_detector: check_detector,
          path_calculator: path_calculator
        )
        
        expect(result).to be false
      end
    end

    context 'with complex move history scenarios' do
      it 'correctly identifies when the specific castling rook has moved' do
        # King hasn't moved, but h1 rook has moved (h1-h2-h1)
        history = Chess::MoveHistory.new
        history.add_move(create_regular_move('h1', 'h2', 'R'))
        history.add_move(create_regular_move('h2', 'h1', 'R'))
        
        allow(check_detector).to receive(:in_check?).and_return(false)
        allow(path_calculator).to receive(:calculate_path_between).and_return([position('f1')])
        
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        
        result = validator.castling_legal?(
          move,
          board,
          history,
          check_detector: check_detector,
          path_calculator: path_calculator
        )
        
        expect(result).to be false
      end

      it 'allows castling when the other rook has moved' do
        # a1 rook has moved, but h1 rook hasn't
        history = Chess::MoveHistory.new
        history.add_move(create_regular_move('a1', 'a2', 'R'))
        
        allow(check_detector).to receive(:in_check?).and_return(false)
        allow(path_calculator).to receive(:calculate_path_between).and_return([position('f1')])
        
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        
        result = validator.castling_legal?(
          move,
          board,
          history,
          check_detector: check_detector,
          path_calculator: path_calculator
        )
        
        expect(result).to be true
      end
    end

    context 'with different piece colors' do
      it 'correctly identifies white player from uppercase piece' do
        move = create_castling_move('e1', 'g1', 'K', 'h1')
        
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER)
          .and_return(false)
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::WHITE_PLAYER, anything)
          .and_return(false)
        allow(path_calculator).to receive(:calculate_path_between).and_return([])
        
        result = validator.castling_legal?(
          move,
          board,
          move_history,
          check_detector: check_detector,
          path_calculator: path_calculator
        )
        
        expect(result).to be true
      end

      it 'correctly identifies black player from lowercase piece' do
        move = create_castling_move('e8', 'g8', 'k', 'h8')
        
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::BLACK_PLAYER)
          .and_return(false)
        allow(check_detector).to receive(:in_check?)
          .with(board, Chess::ChessNotation::BLACK_PLAYER, anything)
          .and_return(false)
        allow(path_calculator).to receive(:calculate_path_between).and_return([])
        
        result = validator.castling_legal?(
          move,
          board,
          move_history,
          check_detector: check_detector,
          path_calculator: path_calculator
        )
        
        expect(result).to be true
      end
    end
  end
end
