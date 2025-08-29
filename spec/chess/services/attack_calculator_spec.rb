# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for AttackCalculator

describe Chess::AttackCalculator do
  # Helper method to create real Position objects
  def position(square)
    Chess::Position.from_algebraic(square)
  end

  def create_board_with_pieces(piece_placements)
    board = Chess::Board.new
    piece_placements.each do |square, piece|
      board.place_piece(position(square), piece)
    end
    board
  end

  describe '.generate_attack_squares' do
    context 'when pawn attacks' do
      it 'returns diagonal attack squares for white pawn' do
        attacks = described_class.generate_attack_squares(position('d4'), 'P')
        expected_positions = %w[c5 e5].map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end

      it 'returns diagonal attack squares for black pawn' do
        attacks = described_class.generate_attack_squares(position('d4'), 'p')
        expected_positions = %w[c3 e3].map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end

      it 'handles edge cases for white pawn on a-file' do
        attacks = described_class.generate_attack_squares(position('a4'), 'P')
        expected_positions = %w[b5].map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end
    end

    context 'when rook attacks without board' do
      it 'returns all horizontal and vertical squares from d4' do
        attacks = described_class.generate_attack_squares(position('d4'), 'R')
        expected_squares = %w[d1 d2 d3 d5 d6 d7 d8 a4 b4 c4 e4 f4 g4 h4]
        expected_positions = expected_squares.map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end
    end

    context 'when rook attacks with board containing pieces' do
      it 'stops at first piece encountered but includes that square' do
        board = create_board_with_pieces({ 'd6' => 'P', 'f4' => 'p' })
        attacks = described_class.generate_attack_squares(position('d4'), 'R', board)
        
        # Up stops at d6, right stops at f4, down and left continue to edges
        expected_squares = %w[d1 d2 d3 d5 d6 a4 b4 c4 e4 f4]
        expected_positions = expected_squares.map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end

      it 'continues attacking through empty squares until piece is hit' do
        board = create_board_with_pieces({ 'd7' => 'k' })
        attacks = described_class.generate_attack_squares(position('d4'), 'R', board)
        
        # Should include d5, d6, and d7 (where king is)
        upward_attacks = attacks.select { |pos| pos.square.start_with?('d') && pos.square > 'd4' }
        expect(upward_attacks.map(&:square)).to eq(['d5', 'd6', 'd7'])
      end
    end

    context 'when bishop attacks' do
      it 'returns all diagonal squares from d4 without board' do
        attacks = described_class.generate_attack_squares(position('d4'), 'B')
        diagonal_squares = %w[a1 b2 c3 e5 f6 g7 h8 a7 b6 c5 e3 f2 g1]
        expected_positions = diagonal_squares.map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end

      it 'stops at pieces on diagonals when board provided' do
        board = create_board_with_pieces({ 'f6' => 'n', 'b2' => 'P' })
        attacks = described_class.generate_attack_squares(position('d4'), 'B', board)
        
        # Should stop at f6 on one diagonal, b2 on another
        expect(attacks.map(&:square)).to include('e5', 'f6') # stops at f6
        expect(attacks.map(&:square)).to include('c3', 'b2') # stops at b2
        expect(attacks.map(&:square)).not_to include('g7', 'a1') # blocked squares
      end
    end

    context 'when queen attacks' do
      it 'combines rook and bishop attacks without board' do
        attacks = described_class.generate_attack_squares(position('d4'), 'Q')
        
        # Should have all rook moves (14) + all bishop moves (13) = 27 squares
        expect(attacks.length).to eq(27)
        
        # Should include horizontal, vertical, and diagonal squares
        expect(attacks.map(&:square)).to include('d8', 'h4', 'a1', 'g7')
      end

      it 'stops at pieces in all directions when board provided' do
        board = create_board_with_pieces({ 'd6' => 'P', 'f4' => 'p', 'f6' => 'n' })
        attacks = described_class.generate_attack_squares(position('d4'), 'Q', board)
        
        # Should stop at each piece but include those squares
        expect(attacks.map(&:square)).to include('d6', 'f4', 'f6')
        expect(attacks.map(&:square)).not_to include('d7', 'g4', 'g7')
      end
    end

    context 'when knight attacks' do
      it 'returns all 8 L-shaped moves from d4' do
        attacks = described_class.generate_attack_squares(position('d4'), 'N')
        expected_squares = %w[c6 e6 f5 f3 e2 c2 b3 b5]
        expected_positions = expected_squares.map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end

      it 'returns only valid moves from corner position' do
        attacks = described_class.generate_attack_squares(position('a1'), 'n')
        expected_positions = %w[b3 c2].map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end

      it 'ignores board state since knights jump over pieces' do
        board = create_board_with_pieces({ 'c3' => 'P', 'd3' => 'p', 'e3' => 'R' })
        attacks = described_class.generate_attack_squares(position('d4'), 'n', board)
        expected_squares = %w[c6 e6 f5 f3 e2 c2 b3 b5]
        expected_positions = expected_squares.map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end
    end

    context 'when king attacks' do
      it 'returns all 8 adjacent squares from d4' do
        attacks = described_class.generate_attack_squares(position('d4'), 'K')
        expected_squares = %w[c3 c4 c5 d3 d5 e3 e4 e5]
        expected_positions = expected_squares.map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end

      it 'returns valid adjacent squares from corner position' do
        attacks = described_class.generate_attack_squares(position('a1'), 'k')
        expected_positions = %w[a2 b1 b2].map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end

      it 'ignores board state since king only moves one square' do
        board = create_board_with_pieces({ 'c3' => 'P', 'd5' => 'q' })
        attacks = described_class.generate_attack_squares(position('d4'), 'K', board)
        expected_squares = %w[c3 c4 c5 d3 d5 e3 e4 e5]
        expected_positions = expected_squares.map { position(it) }
        
        expect(attacks).to contain_exactly(*expected_positions)
      end
    end

    context 'when invalid or empty piece' do
      it 'returns empty array for nil piece' do
        attacks = described_class.generate_attack_squares(position('d4'), nil)
        
        expect(attacks).to be_empty
      end

      it 'returns empty array for invalid piece symbol' do
        attacks = described_class.generate_attack_squares(position('d4'), 'X')
        
        expect(attacks).to be_empty
      end
    end
  end
end