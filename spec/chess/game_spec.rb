# frozen_string_literal: true

require_relative '../../lib/chess'

# Tests for the Chess Game class

describe Game do
  let(:new_game) { Game.new }
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
