# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Game class

describe Game do
  let(:new_game) { Game.new }
  end

  describe '.from_fen' do
    context 'when creating a new game from start positions' do
            let(:starting_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

            it "returns that it is white's turn to move" do
        result = starting_board.active_color
        expect(result).to eq('w')
      end
      it 'returns 0 for half move clock' do
        expect(starting_board.half_move_clock).to eq(0)
      end

      it 'returns 1 for full move number' do
        expect(starting_board.full_move_number).to eq(1)
      end
          context 'when loading a midway game from fen' do
            subject(:midway_game) { described_class.from_fen(after_move_fen) }

            let(:after_move_fen) { 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1' }
      it 'returns active player color is black' do
        expect(mid_game_board.active_color).to eq('b')
      end

      it 'returns 0 for half move clock' do
        expect(mid_game_board.half_move_clock).to eq(0)
      end

      it 'returns 1 for full move number' do
        expect(mid_game_board.full_move_number).to eq(1)
      end
context 'when loading an end game from fen'
      subject(:end_game) { described_class.from_fen(end_game_fen) }

      let(:end_game_fen) { '3B4/K7/2k1b1p1/1p2Pp1p/3P3P/2P3P1/8/8 w - - 0 74' }

      it 'returns active player color is white' do
        expect(end_game.active_color).to eq('w')
      end

      it 'returns 0 for half move clock' do
        expect(end_game.half_move_clock).to eq(0)
      end

      it 'returns 74 for full move number' do
        expect(end_game.full_move_number).to eq(74)
      end

  end
  describe '#to_fen' do
    context 'when starting a new game' do
      it 'returns the fen piece placement data in the correct order' do
        result = new_game.to_fen
        starting_fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
        expect(result).to eq(starting_fen)
      end
    end

    context 'when creating FEN from a midway game' do
      subject(:midway_game) { described_class.from_fen(mid_game_fen) }

      let(:mid_game_fen) { 'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2' }

      it 'returns the same FEN as loaded in' do
        result = midway_game.to_fen
        expect(result).to eq(mid_game_fen)
      end
    end

    context 'when creating FEN from end game' do
      subject(:end_game) { described_class.from_fen(end_game_fen) }

      let(:end_game_fen) { '3b2k1/1p3p2/p1p5/2P4p/1P2P1p1/5p2/5P2/4RK2 w - - 0 0' }

      it 'returns the same FEN as loaded in' do
        result = end_game.to_fen
        expect(result).to eq(end_game_fen)
      end
    end

    context 'when creating FEN from Fischer vs Byrne, 1956 game after queen sacrifice' do
      subject(:game_of_the_century) { described_class.from_fen(game_of_the_century_fen) }

      let(:game_of_the_century_fen) { 'r3r1k1/pp3ppp/1qn2n2/3p1b2/3P1B2/2N2N2/PP2QPPP/2RR2K1 b - - 0 18' }

      it 'results in same FEN as loaded in' do
        result = game_of_the_century.to_fen
        expect(result).to eq(game_of_the_century_fen)
      end
    end
  end

  describe '#start' do
    context 'when starting the game' do
      let(:starting_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
      it 'returns white as the active player color' do
        current_player = start_board.active_color
        expect(current_player).to eq('w')
      end

      it 'returns starting position fen string' do
        result = start_board.to_fen
        expect(result).to eq(starting_fen)
      end

    end
  end
  describe '#current_player' do
    context 'when the game starts' do
    end
  end
  describe '#switch_turns' do
    context 'when the current player ends a turn' do
    end
  end

  describe '#play_turn' do
    context 'when the current player gets a turn' do
    end
  end
end
