require_relative '../../../lib/chess'

# Tests for EnPassantManager

describe Chess::EnPassantManager do
  describe '.en_passant_legal?' do
    # Helper methods to create real Position and Move objects
    def position(square)
      Chess::Position.from_algebraic(square)
    end

    def create_move(
      from_square:,
      to_square:,
      piece:,
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      double_pawn_move: false,
      en_passant_target: nil,
      opponent_last_move: nil
    )
      Chess::Move.new(
        from_position: position(from_square),
        to_position: position(to_square),
        piece: piece,
        fen: fen,
        double_pawn_move: double_pawn_move,
        en_passant_target: en_passant_target,
        opponent_last_move: opponent_last_move
      )
    end

    def create_en_passant_move(
      from_square:,
      to_square:,
      piece:,
      en_passant_target_square:,
      opponent_last_move:,
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
    )
      create_move(
        from_square: from_square,
        to_square: to_square,
        piece: piece,
        fen: fen,
        double_pawn_move: false,
        en_passant_target: position(en_passant_target_square),
        opponent_last_move: opponent_last_move
      )
    end

    def create_double_pawn_move(from_square:, to_square:, piece:, fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
      create_move(
        from_square: from_square,
        to_square: to_square,
        piece: piece,
        fen: fen,
        double_pawn_move: true
      )
    end

    context 'when piece is not a pawn' do
      it 'returns false for white king' do
        move = create_move(
          from_square: 'e1',
          to_square: 'e2',
          piece: 'K'
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end

      it 'returns false for black queen' do
        move = create_move(
          from_square: 'd8',
          to_square: 'd7',
          piece: 'q'
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end

      it 'returns false for white rook' do
        move = create_move(
          from_square: 'a1',
          to_square: 'a2',
          piece: 'R'
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end
    end

    context 'when piece is a pawn but current move is a double pawn move' do
      it 'returns false for white pawn making double move' do
        move = create_double_pawn_move(
          from_square: 'e2',
          to_square: 'e4',
          piece: 'P'
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end

      it 'returns false for black pawn making double move' do
        move = create_double_pawn_move(
          from_square: 'e7',
          to_square: 'e5',
          piece: 'p'
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end
    end

    context 'when end position does not match en passant target' do
      it 'returns false when target square is different from destination' do
        opponent_move = create_double_pawn_move(
          from_square: 'd7',
          to_square: 'd5',
          piece: 'p'
        )

        move = create_en_passant_move(
          from_square: 'e5',
          to_square: 'f6',  # Moving to f6
          piece: 'P',
          en_passant_target_square: 'd6',  # But target is d6
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end
    end

    context 'when there is no opponent last move' do
      it 'returns false' do
        move = create_en_passant_move(
          from_square: 'e5',
          to_square: 'd6',
          piece: 'P',
          en_passant_target_square: 'd6',
          opponent_last_move: nil
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end
    end

    context 'when opponent last move was not a double pawn move' do
      it 'returns false when opponent made single pawn move' do
        opponent_move = create_move(
          from_square: 'd6',
          to_square: 'd5',
          piece: 'p',
          double_pawn_move: false
        )

        move = create_en_passant_move(
          from_square: 'e5',
          to_square: 'd6',
          piece: 'P',
          en_passant_target_square: 'd6',
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end

      it 'returns false when opponent moved a non-pawn piece' do
        opponent_move = create_move(
          from_square: 'b8',
          to_square: 'c6',
          piece: 'n',
          double_pawn_move: false
        )

        move = create_en_passant_move(
          from_square: 'e5',
          to_square: 'd6',
          piece: 'P',
          en_passant_target_square: 'd6',
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end
    end

    context 'when opponent pawn is not adjacent to current pawn' do
      it 'returns false when opponent pawn moved to non-adjacent square' do
        # Opponent's pawn moves from a7 to a5 (not adjacent to white pawn on e5)
        opponent_move = create_double_pawn_move(
          from_square: 'a7',
          to_square: 'a5',
          piece: 'p'
        )

        move = create_en_passant_move(
          from_square: 'e5',
          to_square: 'd6',
          piece: 'P',
          en_passant_target_square: 'd6',
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end
    end

    context 'when all conditions for en passant are met' do
      it 'returns true for valid white pawn en passant capture to the left' do
        # Black pawn moves from d7 to d5 (double move)
        opponent_move = create_double_pawn_move(
          from_square: 'd7',
          to_square: 'd5',
          piece: 'p'
        )

        # White pawn on e5 captures en passant to d6
        move = create_en_passant_move(
          from_square: 'e5',
          to_square: 'd6',
          piece: 'P',
          en_passant_target_square: 'd6',
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be true
      end

      it 'returns true for valid white pawn en passant capture to the right' do
        # Black pawn moves from f7 to f5 (double move)
        opponent_move = create_double_pawn_move(
          from_square: 'f7',
          to_square: 'f5',
          piece: 'p'
        )

        # White pawn on e5 captures en passant to f6
        move = create_en_passant_move(
          from_square: 'e5',
          to_square: 'f6',
          piece: 'P',
          en_passant_target_square: 'f6',
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be true
      end

      it 'returns true for valid black pawn en passant capture to the left' do
        # White pawn moves from c2 to c4 (double move)
        opponent_move = create_double_pawn_move(
          from_square: 'c2',
          to_square: 'c4',
          piece: 'P'
        )

        # Black pawn on d4 captures en passant to c3
        move = create_en_passant_move(
          from_square: 'd4',
          to_square: 'c3',
          piece: 'p',
          en_passant_target_square: 'c3',
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be true
      end

      it 'returns true for valid black pawn en passant capture to the right' do
        # White pawn moves from e2 to e4 (double move)
        opponent_move = create_double_pawn_move(
          from_square: 'e2',
          to_square: 'e4',
          piece: 'P'
        )

        # Black pawn on d4 captures en passant to e3
        move = create_en_passant_move(
          from_square: 'd4',
          to_square: 'e3',
          piece: 'p',
          en_passant_target_square: 'e3',
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be true
      end
    end

    context 'edge cases' do
      it 'returns false when piece is nil' do
        move = create_move(
          from_square: 'e2',
          to_square: 'e4',
          piece: nil
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end

      it 'returns false when piece is empty string' do
        move = create_move(
          from_square: 'e2',
          to_square: 'e4',
          piece: ''
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end

      it 'returns false when en passant target is nil but opponent made double pawn move' do
        opponent_move = create_double_pawn_move(
          from_square: 'd7',
          to_square: 'd5',
          piece: 'p'
        )

        move = create_move(
          from_square: 'e5',
          to_square: 'd6',
          piece: 'P',
          en_passant_target: nil,  # No en passant target set
          opponent_last_move: opponent_move
        )
        
        result = described_class.en_passant_legal?(move)
        
        expect(result).to be false
      end
    end
  end
end
