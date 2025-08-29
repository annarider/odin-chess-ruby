# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for MovePatterns module

describe Chess::MovePatterns do
  # Helper method to create real Position objects
  def position(square)
    Chess::Position.from_algebraic(square)
  end

  def create_board_with_piece(square, piece)
    board = Chess::Board.new
    board.place_piece(position(square), piece)
    board
  end

  describe '.linear_moves' do
    context 'when generating rook moves without board constraints' do
      it 'returns all 14 possible squares from d4' do
        moves = described_class.linear_moves(position('d4'), Chess::Directions::ROOK)
        expected_squares = %w[d1 d2 d3 d5 d6 d7 d8 a4 b4 c4 e4 f4 g4 h4]
        expected_positions = expected_squares.map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end

      it 'returns 14 squares from corner position a1' do
        moves = described_class.linear_moves(position('a1'), Chess::Directions::ROOK)
        # 7 up the a-file + 7 along the 1st rank
        up_file = %w[a2 a3 a4 a5 a6 a7 a8]
        across_rank = %w[b1 c1 d1 e1 f1 g1 h1]
        expected_positions = (up_file + across_rank).map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end
    end

    context 'when generating bishop moves without board constraints' do
      it 'returns all 13 diagonal squares from d4' do
        moves = described_class.linear_moves(position('d4'), Chess::Directions::BISHOP)
        diagonal_squares = %w[a1 b2 c3 e5 f6 g7 h8 a7 b6 c5 e3 f2 g1]
        expected_positions = diagonal_squares.map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end
    end

    context 'when board has blocking pieces' do
      it 'stops at piece but includes that square' do
        board = create_board_with_piece('d6', 'P')
        moves = described_class.linear_moves(position('d4'), Chess::Directions::ROOK, board: board)
        
        # Up direction should stop at d6, other directions unblocked
        expected_squares = %w[d1 d2 d3 d5 d6 a4 b4 c4 e4 f4 g4 h4]
        expected_positions = expected_squares.map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end

      it 'continues in unblocked directions when piece blocks one path' do
        board = create_board_with_piece('f4', 'p')
        moves = described_class.linear_moves(position('d4'), Chess::Directions::ROOK, board: board)
        
        # Right direction stops at f4, others continue
        expected_squares = %w[d1 d2 d3 d5 d6 d7 d8 a4 b4 c4 e4 f4]
        expected_positions = expected_squares.map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end
    end
  end

  describe '.single_moves' do
    context 'when generating knight moves' do
      it 'returns all 8 moves from center position d4' do
        moves = described_class.single_moves(position('d4'), Chess::Directions::KNIGHT)
        expected_squares = %w[c6 e6 f5 f3 e2 c2 b3 b5]
        expected_positions = expected_squares.map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end

      it 'returns only valid moves from corner position a1' do
        moves = described_class.single_moves(position('a1'), Chess::Directions::KNIGHT)
        expected_squares = %w[b3 c2]
        expected_positions = expected_squares.map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end
    end

    context 'when generating king moves' do
      it 'returns all 8 adjacent squares from d4' do
        king_directions = Chess::Directions::ROOK + Chess::Directions::BISHOP
        moves = described_class.single_moves(position('d4'), king_directions)
        expected_squares = %w[c3 c4 c5 d3 d5 e3 e4 e5]
        expected_positions = expected_squares.map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end
    end
  end

  describe '.pawn_diagonals' do
    context 'when white pawn' do
      it 'returns both diagonal attacks from d4' do
        moves = described_class.pawn_diagonals(position('d4'), 'P')
        expected_positions = %w[c5 e5].map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end

      it 'returns only valid diagonal from a-file' do
        moves = described_class.pawn_diagonals(position('a4'), 'P')
        expected_positions = %w[b5].map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end

      it 'returns promotion diagonals from 7th rank' do
        moves = described_class.pawn_diagonals(position('g7'), 'P')
        expected_positions = %w[f8 h8].map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end
    end

    context 'when black pawn' do
      it 'returns both diagonal attacks from d5' do
        moves = described_class.pawn_diagonals(position('d5'), 'p')
        expected_positions = %w[c4 e4].map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end

      it 'returns promotion diagonals from 2nd rank' do
        moves = described_class.pawn_diagonals(position('b2'), 'p')
        expected_positions = %w[a1 c1].map { position(it) }
        
        expect(moves).to contain_exactly(*expected_positions)
      end
    end
  end

  describe '.white_piece?' do
    it 'returns true for uppercase pieces' do
      %w[K Q R B N P].each do |piece|
        expect(described_class.white_piece?(piece)).to be true
      end
    end

    it 'returns false for lowercase pieces' do
      %w[k q r b n p].each do |piece|
        expect(described_class.white_piece?(piece)).to be false
      end
    end
  end
end