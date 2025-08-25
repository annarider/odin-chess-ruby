# frozen_string_literal: true

require_relative '../../../lib/chess'

# Tests for Pawn PromotionValidator class

describe Chess::PromotionValidator do
  # Helper methods to create Position and Move objects
  def position(square)
    Chess::Position.from_algebraic(square)
  end

  def create_move(from_square, to_square, piece)
    Chess::Move.new(
      from_position: position(from_square),
      to_position: position(to_square),
      piece: piece
    )
  end

  describe '.promotion_legal?' do
    context 'when piece is not a pawn' do
      let(:move) { create_move('e7', 'e8', 'Q') }

      it 'returns false' do
        expect(described_class.promotion_legal?(move)).to be false
      end
    end

    context 'when piece is a white pawn' do
      context 'and reaches the eighth rank' do
        let(:move) { create_move('e7', 'e8', 'P') }

        it 'returns true' do
          expect(described_class.promotion_legal?(move)).to be true
        end
      end

      context 'and does not reach the eighth rank' do
        let(:move) { create_move('e6', 'e7', 'P') }

        it 'returns false' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end

      context 'and is on any other rank' do
        [2, 3, 4, 5, 6, 7].each do |rank|
          context "moving to rank #{rank}" do
            let(:to_square) { "e#{rank}" }
            let(:from_square) { "e#{rank - 1}" }
            let(:move) { create_move(from_square, to_square, 'P') }

            it 'returns false' do
              expect(described_class.promotion_legal?(move)).to be false
            end
          end
        end
      end
    end

    context 'when piece is a black pawn' do
      context 'and reaches the first rank' do
        let(:move) { create_move('e2', 'e1', 'p') }

        it 'returns true' do
          expect(described_class.promotion_legal?(move)).to be true
        end
      end

      context 'and does not reach the first rank' do
        let(:move) { create_move('e3', 'e2', 'p') }

        it 'returns false' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end

      context 'and is on any other rank' do
        [2, 3, 4, 5, 6, 7].each do |rank|
          context "moving to rank #{rank}" do
            let(:to_square) { "e#{rank}" }
            let(:from_square) { "e#{rank + 1}" }
            let(:move) { create_move(from_square, to_square, 'p') }

            it 'returns false' do
              expect(described_class.promotion_legal?(move)).to be false
            end
          end
        end
      end
    end

    context 'edge cases' do
      context 'when piece is nil' do
        let(:move) { create_move('e7', 'e8', nil) }

        it 'returns false' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end

      context 'when piece is empty string' do
        let(:move) { create_move('e7', 'e8', '') }

        it 'returns false' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end

      context 'when piece is invalid' do
        let(:move) { create_move('e7', 'e8', 'X') }

        it 'returns false' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end
    end

    context 'realistic promotion scenarios' do
      context 'white pawn promoting on eighth rank' do
        let(:move) { create_move('d7', 'd8', 'P') }

        it 'allows promotion' do
          expect(described_class.promotion_legal?(move)).to be true
        end
      end

      context 'black pawn promoting on first rank' do
        let(:move) { create_move('f2', 'f1', 'p') }

        it 'allows promotion' do
          expect(described_class.promotion_legal?(move)).to be true
        end
      end

      context 'white pawn moving to seventh rank (almost promotion)' do
        let(:move) { create_move('d6', 'd7', 'P') }

        it 'does not allow promotion' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end

      context 'black pawn moving to second rank (almost promotion)' do
        let(:move) { create_move('f3', 'f2', 'p') }

        it 'does not allow promotion' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end

      context 'testing different file positions' do
        context 'white pawn promotion on different files' do
          %w[a b c d e f g h].each do |file|
            context "on file #{file}" do
              let(:move) { create_move("#{file}7", "#{file}8", 'P') }

              it 'allows promotion' do
                expect(described_class.promotion_legal?(move)).to be true
              end
            end
          end
        end

        context 'black pawn promotion on different files' do
          %w[a b c d e f g h].each do |file|
            context "on file #{file}" do
              let(:move) { create_move("#{file}2", "#{file}1", 'p') }

              it 'allows promotion' do
                expect(described_class.promotion_legal?(move)).to be true
              end
            end
          end
        end
      end
    end

    context 'boundary testing' do
      context 'white pawn reaching eighth rank (promotion rank)' do
        let(:move) { create_move('a7', 'a8', 'P') }

        it 'returns true' do
          expect(described_class.promotion_legal?(move)).to be true
        end
      end

      context 'black pawn reaching first rank (promotion rank)' do
        let(:move) { create_move('h2', 'h1', 'p') }

        it 'returns true' do
          expect(described_class.promotion_legal?(move)).to be true
        end
      end

      context 'white pawn on wrong promotion rank (first rank)' do
        let(:move) { create_move('a2', 'a1', 'P') }

        it 'returns false' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end

      context 'black pawn on wrong promotion rank (eighth rank)' do
        let(:move) { create_move('h7', 'h8', 'p') }

        it 'returns false' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end
    end

    context 'capture promotions' do
      context 'white pawn capturing on promotion rank' do
        let(:move) { create_move('e7', 'f8', 'P') }

        it 'allows promotion' do
          expect(described_class.promotion_legal?(move)).to be true
        end
      end

      context 'black pawn capturing on promotion rank' do
        let(:move) { create_move('d2', 'c1', 'p') }

        it 'allows promotion' do
          expect(described_class.promotion_legal?(move)).to be true
        end
      end

      context 'white pawn capturing but not on promotion rank' do
        let(:move) { create_move('e6', 'f7', 'P') }

        it 'does not allow promotion' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end

      context 'black pawn capturing but not on promotion rank' do
        let(:move) { create_move('d3', 'c2', 'p') }

        it 'does not allow promotion' do
          expect(described_class.promotion_legal?(move)).to be false
        end
      end
    end
  end
end
