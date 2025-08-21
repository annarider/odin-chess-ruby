# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for class Chess::Move Validator

describe Chess::MoveValidator do
  subject(:validator) { described_class }

  let(:board) { Chess::Board.new }
  let(:move_history) { Chess::MoveHistory.new }

  describe '.move_legal?' do
    context 'when a white knight in the middle of an empty board moves' do
      let(:knight_start) { Chess::Position.from_algebraic('d5') }
      let(:knight_destination) { Chess::Position.from_algebraic('c3') }
      let(:move) { Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N') }

      before do
        board.place_piece(knight_start, 'N')
      end

      it 'returns true when the destination square is empty' do
        result = validator.move_legal?(board, move)
        expect(result).to be true
      end
    end

    context 'when a black rook moves diagonally' do
      it 'returns false' do
        rook_start = Chess::Position.from_algebraic('a8')
        rook_destination = Chess::Position.from_algebraic('f7')
        move = Chess::Move.new(from_position: rook_start, to_position: rook_destination, piece: 'N')
        board.place_piece(rook_start, 'N')
        expect(validator.move_legal?(board, move)).to be false
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
        expect(validator.move_legal?(board, move)).to be true
      end

      it 'returns false for a black pawn' do
        board.place_piece(knight_destination, 'p')
        expect(validator.move_legal?(board, move)).to be false
      end
    end

    context 'when starting a new game' do
      subject(:start_board) { Chess::Board.start_positions(add_pieces: true) }

      it 'returns false when white bishop path is blocked' do
        bishop_start = Chess::Position.from_algebraic('c1')
        bishop_destination = Chess::Position.from_algebraic('e3')
        move = Chess::Move.new(from_position: bishop_start, to_position: bishop_destination, piece: 'B')
        expect(validator.move_legal?(start_board, move)).to be false
      end

      it 'returns true for white knight which can leap over pieces' do
        knight_start = Chess::Position.from_algebraic('b1')
        knight_destination = Chess::Position.from_algebraic('c3')
        move = Chess::Move.new(from_position: knight_start, to_position: knight_destination, piece: 'N')
        expect(validator.move_legal?(board, move)).to be true
      end
    end

    context 'when validating a pawn move' do
      let(:white_pawn_start) { Chess::Position.from_algebraic('e2') }
      let(:white_pawn_destination) { Chess::Position.from_algebraic('e4') }
      let(:white_pawn_move) do
        Chess::Move.new(from_position: white_pawn_start, to_position: white_pawn_destination, piece: 'P')
      end
      let(:move_history) { [] }

      before do
        board.place_piece(white_pawn_start, 'P')
        allow(Chess::MoveCalculator).to receive(:generate_possible_moves)
          .and_return([white_pawn_destination])
        allow(Chess::PawnMoveValidator).to receive(:valid_move?).and_return(true)
      end

      it 'sends valid_move? message to PawnMoveValidator service' do
        allow(Chess::PawnMoveValidator).to receive(:valid_move?)
        validator.move_legal?(board, white_pawn_move, move_history)
        expect(Chess::PawnMoveValidator).to have_received(:valid_move?)
          .with(white_pawn_move, move_history)
      end
    end

    context 'when validating a black pawn move' do
      let(:black_pawn_start) { Chess::Position.from_algebraic('d7') }
      let(:black_pawn_destination) { Chess::Position.from_algebraic('d6') }
      let(:black_pawn_move) do
        Chess::Move.new(from_position: black_pawn_start, to_position: black_pawn_destination, piece: 'p')
      end
      let(:move_history) { [] }

      before do
        board.place_piece(black_pawn_start, 'p')
        # Stub the other validation methods to isolate the outgoing command test
        allow(Chess::MoveCalculator).to receive(:generate_possible_moves)
          .and_return([black_pawn_destination])
        allow(Chess::PawnMoveValidator).to receive(:valid_move?).and_return(true)
      end

      it 'sends valid_move? message to PawnMoveValidator with correct arguments' do
        allow(Chess::PawnMoveValidator).to receive(:valid_move?)
        validator.move_legal?(board, black_pawn_move, move_history)
        expect(Chess::PawnMoveValidator).to have_received(:valid_move?)
          .with(black_pawn_move, move_history)
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
        allow(Chess::PawnMoveValidator).to receive(:valid_move?)
        validator.move_legal?(board, knight_move, move_history)
        expect(Chess::PawnMoveValidator).not_to have_received(:valid_move?)
      end
    end

    context 'when PawnMoveValidator returns false' do
      let(:invalid_pawn_start) { Chess::Position.from_algebraic('e3') }
      let(:invalid_pawn_destination) { Chess::Position.from_algebraic('e5') }
      let(:invalid_pawn_move) do
        Chess::Move.new(from_position: invalid_pawn_start, to_position: invalid_pawn_destination, piece: 'P')
      end
      let(:move_history) { [] }

      before do
        board.place_piece(invalid_pawn_start, 'P')
        allow(Chess::MoveCalculator).to receive(:generate_possible_moves)
          .and_return([invalid_pawn_destination])
        allow(Chess::PawnMoveValidator).to receive(:valid_move?).and_return(false)
      end

      it 'returns false when pawn validation fails' do
        result = validator.move_legal?(board, invalid_pawn_move, move_history)
        expect(result).to be false
      end
    end

    context 'when validating king moves (triggers castling validation)' do
      context 'with a regular white king move' do
        let(:king_start) { Chess::Position.from_algebraic('e1') }
        let(:king_destination) { Chess::Position.from_algebraic('g1') }
        let(:king_move) do
          Chess::Move.new(
            from_position: king_start,
            to_position: king_destination,
            piece: 'K'
          )
        end

        before do
          board.place_piece(king_start, 'K')
        end

        it 'calls CastlingValidator for white king moves' do
          allow(Chess::CastlingValidator).to receive(:castling_legal?)
            .and_call_original
          validator.move_legal?(board, king_move, move_history)
          expect(Chess::CastlingValidator).to have_received(:castling_legal?)
            .with(board, king_move, move_history)
        end
      end

      context 'with a regular black king move' do
        let(:king_start) { Chess::Position.from_algebraic('e8') }
        let(:king_destination) { Chess::Position.from_algebraic('g8') }
        let(:king_move) do
          Chess::Move.new(
            from_position: king_start,
            to_position: king_destination,
            piece: 'k'
          )
        end

        before do
          board.place_piece(king_start, 'k')
        end

        it 'calls CastlingValidator for black king moves' do
          allow(Chess::CastlingValidator).to receive(:castling_legal?)
            .and_call_original
          validator.move_legal?(board, king_move, move_history)
          expect(Chess::CastlingValidator).to have_received(:castling_legal?)
            .with(board, king_move, move_history)
        end
      end

      context 'with a king capturing move' do
        let(:king_start) { Chess::Position.from_algebraic('e4') }
        let(:king_destination) { Chess::Position.from_algebraic('e5') }
        let(:capture_move) do
          Chess::Move.new(
            from_position: king_start,
            to_position: king_destination,
            piece: 'K'
          )
        end

        before do
          board.place_piece(king_start, 'K')
          board.place_piece(king_destination, 'p') # Enemy pawn to capture
        end

        it 'still calls CastlingValidator even for capturing moves' do
          allow(Chess::CastlingValidator).to receive(:castling_legal?)
            .and_call_original
          validator.move_legal?(board, capture_move, move_history)
          expect(Chess::CastlingValidator).to have_received(:castling_legal?)
            .with(board, capture_move, move_history)
        end
      end
    end

    context 'when validating non-king moves' do
      context 'with a queen move' do
        let(:queen_start) { Chess::Position.from_algebraic('d1') }
        let(:queen_destination) { Chess::Position.from_algebraic('d4') }
        let(:queen_move) do
          Chess::Move.new(
            from_position: queen_start,
            to_position: queen_destination,
            piece: 'Q'
          )
        end

        before do
          board.place_piece(queen_start, 'Q')
        end

        it 'does not call CastlingValidator' do
          allow(Chess::CastlingValidator).to receive(:castling_legal?)
          validator.move_legal?(board, queen_move, move_history)
          expect(Chess::CastlingValidator).not_to have_received(:castling_legal?)
        end
      end

      context 'with a rook move' do
        let(:rook_start) { Chess::Position.from_algebraic('a1') }
        let(:rook_destination) { Chess::Position.from_algebraic('a5') }
        let(:rook_move) do
          Chess::Move.new(from_position: rook_start, to_position: rook_destination, piece: 'R')
        end

        before do
          board.place_piece(rook_start, 'R')
        end

        it 'does not call CastlingValidator' do
          allow(Chess::CastlingValidator).to receive(:castling_legal?)
          validator.move_legal?(board, rook_move, move_history)
          expect(Chess::CastlingValidator).not_to have_received(:castling_legal?)
        end
      end

      context 'with a pawn move' do
        let(:pawn_start) { Chess::Position.from_algebraic('e2') }
        let(:pawn_destination) { Chess::Position.from_algebraic('e4') }
        let(:pawn_move) do
          Chess::Move.new(from_position: pawn_start, to_position: pawn_destination, piece: 'P')
        end

        before do
          board.place_piece(pawn_start, 'P')
        end

        it 'does not call CastlingValidator' do
          allow(Chess::CastlingValidator).to receive(:castling_legal?)
          validator.move_legal?(board, pawn_move, move_history)
          expect(Chess::CastlingValidator).not_to have_received(:castling_legal?)
        end
      end
    end

    context 'when other validations fail before castling' do
      let(:king_start) { Chess::Position.from_algebraic('e1') }
      let(:impossible_destination) { Chess::Position.from_algebraic('a8') } # Invalid king move
      let(:invalid_move) do
        Chess::Move.new(from_position: king_start, to_position: impossible_destination, piece: 'K')
      end

      before do
        board.place_piece(king_start, 'K')
      end

      it 'does not call CastlingValidator when move is impossible' do
        allow(Chess::CastlingValidator).to receive(:castling_legal?)
        result = validator.move_legal?(board, invalid_move, move_history)
        expect(Chess::CastlingValidator).not_to have_received(:castling_legal?)
        expect(result).to be false
      end
    end
  end
end
