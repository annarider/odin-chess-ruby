# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for class Chess::Move Validator

describe Chess::MoveValidator do
  subject(:validator) { described_class.new }

  let(:board) { Chess::Board.new }

  describe '.is_move_legal?' do
    context 'when a white knight in the middle of an empty board moves' do
      let(:knight_start) { Chess::Position.from_algebraic('d5') }
      let(:knight_destination) { Chess::Position.from_algebraic('c3') }
      let(:move) { Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N') }

      before do
        board.place_piece(knight_start, 'N')
      end

      it 'returns true when the destination square is empty' do
        result = described_class.is_move_legal?(board, move)
        expect(result).to be true
      end
    end

    context 'when a black rook moves diagonally' do
      it 'returns false' do
        rook_start = Chess::Position.from_algebraic('a8')
        rook_destination = Chess::Position.from_algebraic('f7')
        move = Chess::Move.new(from_position: rook_start, to_position: rook_destination, piece: 'N')
        board.place_piece(rook_start, 'N')
        expect(described_class.is_move_legal?(board, move)).to be false
      end
    end

    context 'when a black knight captures' do
      let(:knight_start) { Chess::Position.from_algebraic('f6') }
      let(:knight_destination) { Chess::Position.from_algebraic('e4') }
      let(:move) { Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'n') }

      before do
        board.place_piece(knight_start, 'n')
      end

      it 'returns true for a white pawn' do
        board.place_piece(knight_destination, 'P')
        expect(described_class.is_move_legal?(board, move)).to be true
      end

      it 'returns false for a black pawn' do
        board.place_piece(knight_destination, 'p')
        expect(described_class.is_move_legal?(board, move)).to be false
      end
    end

    context 'when starting a new game' do
      subject(:start_board) { Chess::Board.start_positions(add_pieces: true) }

      it 'returns false when white bishop path is blocked' do
        starting_board = Chess::Board.start_positions(add_pieces: true)
        bishop_start = Chess::Position.from_algebraic('c1')
        bishop_destination = Chess::Position.from_algebraic('e3')
        move = Chess::Move.new(from_position: bishop_start, to_position: bishop_destination, piece: 'B')
        expect(described_class.is_move_legal?(starting_board, move)).to be false
      end

      it 'returns true for white knight which can leap over pieces' do
        knight_start = Chess::Position.from_algebraic('b1')
        knight_destination = Chess::Position.from_algebraic('c3')
        move = Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N')
        expect(described_class.is_move_legal?(board, move)).to be true
      end
    end
    context 'when validating a pawn move' do
      let(:white_pawn_start) { Chess::Position.from_algebraic('e2') }
      let(:white_pawn_destination) { Chess::Position.from_algebraic('e4') }
      let(:white_pawn_move) { Chess::Move.new(from_position: white_pawn_start, to_position: white_pawn_destination, piece: 'P') }
      let(:move_history) { [] }
      before do 
        board.place_piece(white_pawn_start, 'P')
        allow(Chess::MoveCalculator).to receive(:generate_possible_moves)
          .and_return([white_pawn_destination])
        allow(Chess::PawnMoveValidator).to receive(:valid_move?).and_return(true)
      end
      it 'sends valid_move? message to PawnMoveValidator service' do
        expect(Chess::PawnMoveValidator).to receive(:valid_move?)
          .with(white_pawn_move, move_history)

          described_class.is_move_legal?(board, white_pawn_move, move_history)
      end
    end
    context 'when validating a black pawn move' do
      let(:black_pawn_start) { Chess::Position.from_algebraic('d7') }
      let(:black_pawn_destination) { Chess::Position.from_algebraic('d6') }
      let(:black_pawn_move) { Chess::Move.new(from_position: black_pawn_start, to_position: black_pawn_destination, piece: 'p') }
      let(:move_history) { [] }
      before do
        board.place_piece(black_pawn_start, 'p')
        # Stub the other validation methods to isolate the outgoing command test
        allow(Chess::MoveCalculator).to receive(:generate_possible_moves)
          .and_return([black_pawn_destination])
        allow(Chess::PawnMoveValidator).to receive(:valid_move?).and_return(true)
      end
      it 'sends valid_move? message to PawnMoveValidator with correct arguments' do
        expect(Chess::PawnMoveValidator).to receive(:valid_move?)
          .with(black_pawn_move, move_history)

          described_class.is_move_legal?(board, black_pawn_move, move_history)
      end
    end
    context 'when validating a non-pawn move' do
      let(:knight_start) { Chess::Position.from_algebraic('b1') }
      let(:knight_destination) { Chess::Position.from_algebraic('c3') }
      let(:knight_move) { Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N') }
      let(:move_history) { [] }
      before do
        board.place_piece(knight_start, 'N')
        allow(Chess::MoveCalculator).to receive(:generate_possible_moves)
          .and_return([knight_destination])
      end
      it 'does not send valid_move? message to PawnMoveValidator' do
        expect(Chess::PawnMoveValidator).not_to receive(:valid_move?)

        described_class.is_move_legal?(board, knight_move, move_history)
      end
    end
    context 'when PawnMoveValidator returns false' do
      let(:invalid_pawn_start) { Chess::Position.from_algebraic('e3') }
      let(:invalid_pawn_destination) { Chess::Position.from_algebraic('e5') }
      let(:invalid_pawn_move) { Chess::Move.new(from_position: invalid_pawn_start, to_position: invalid_pawn_destination, piece: 'P') }
      let(:move_history) { [] }
      before do
        board.place_piece(invalid_pawn_start, 'P')
        allow(Chess::MoveCalculator).to receive(:generate_possible_moves)
          .and_return([invalid_pawn_destination])
        allow(Chess::PawnMoveValidator).to receive(:valid_move?).and_return(false)
      end
      it 'returns false when pawn validation fails' do
        result = described_class.is_move_legal?(board, invalid_pawn_move, move_history)
        expect(result).to be false
      end
    end
  end
end
