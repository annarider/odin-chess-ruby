# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::GameController do
  describe '#initialize' do
    context 'with no arguments' do
      it 'creates a new game by default' do
        controller = described_class.new
        expect(controller.state).to be_a(Chess::GameState)
      end
    end

    context 'with a game provided' do
      it 'uses the provided game' do
        custom_game = Chess::GameState.new
        controller = described_class.new(custom_game)
        expect(controller.state).to be(custom_game)
      end
    end
  end

  describe '#handle_move' do
    let(:controller) { described_class.new }
    
    context 'when move is valid' do
      it 'changes the active player' do
        # Test behavior: valid moves should switch turns
        from_pos = Chess::Position.from_algebraic('e2')
        to_pos = Chess::Position.from_algebraic('e4')

        expect { controller.send(:handle_move, from_pos, to_pos) }
          .to change(controller.state, :active_color)
          .from(Chess::ChessNotation::WHITE_PLAYER)
          .to(Chess::ChessNotation::BLACK_PLAYER)
      end

      it 'increases the full move number' do
        # Test behavior: valid moves increment game progress
        from_pos = Chess::Position.from_algebraic('e2')
        to_pos = Chess::Position.from_algebraic('e4')

        expect { controller.send(:handle_move, from_pos, to_pos) }
          .to change(controller.state, :full_move_number).by(1)
      end
    end

    context 'when move is invalid' do
      before do
        # Stub interface to prevent output/recursion during test
        allow(Chess::Interface).to receive(:announce_invalid_move)
        allow(controller).to receive(:play_turn)
      end
      
      it 'does not change the active player' do
        # Test behavior: invalid moves should not affect game state
        from_pos = Chess::Position.from_algebraic('e5') # No piece here
        to_pos = Chess::Position.from_algebraic('e6')

        expect { controller.send(:handle_move, from_pos, to_pos) }
          .not_to change(controller.state, :active_color)
      end

      it 'does not change the full move number' do
        # Test behavior: invalid moves don't count as game progress
        from_pos = Chess::Position.from_algebraic('e5') # No piece here
        to_pos = Chess::Position.from_algebraic('e6')

        expect { controller.send(:handle_move, from_pos, to_pos) }
          .not_to change(controller.state, :full_move_number)
      end

      it 'continues the turn when move is invalid' do
        # Test command: invalid moves should trigger retry
        from_pos = Chess::Position.from_algebraic('e5') # No piece here
        to_pos = Chess::Position.from_algebraic('e6')
        allow(controller).to receive(:play_turn)

        controller.send(:handle_move, from_pos, to_pos)

        expect(controller).to have_received(:play_turn)
      end
    end
  end

  describe '#announce_game_end' do
    context 'when white wins' do
      it 'announces white as winner' do
        # Use real checkmate position where white wins
        game = Chess::GameState.from_fen('r1bqkb1r/pppp1Qpp/2n2n2/4p3/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 4')
        controller = described_class.new(game)

        expect { controller.send(:announce_game_end) }.to output(/White won!/).to_stdout
      end
    end

    context 'when black wins' do
      it 'announces black as winner' do
        # Use real checkmate position where black wins
        game = Chess::GameState.from_fen('rnb1kbnr/pppp1ppp/8/4p3/7q/5P2/PPPPP1PP/RNBQKBNR w KQkq - 1 3')
        controller = described_class.new(game)

        expect { controller.send(:announce_game_end) }.to output(/Black won!/).to_stdout
      end
    end

    context 'when game is a draw' do
      it 'announces a draw' do
        # Use real stalemate position
        game = Chess::GameState.from_fen('8/8/8/8/8/1k6/1P6/1K6 b - - 0 1')
        controller = described_class.new(game)

        expect { controller.send(:announce_game_end) }.to output(/It's a draw/).to_stdout
      end
    end
  end

  describe '#handle_quit' do
    it 'outputs farewell message and exits' do
      controller = described_class.new
      
      expect { controller.send(:handle_quit) }.to output(/Thanks for playing!/).to_stdout.and raise_error(SystemExit)
    end
  end

  describe '#handle_save' do
    it 'outputs not implemented message and continues turn' do
      controller = described_class.new
      allow(controller).to receive(:play_turn)
      
      expect { controller.send(:handle_save) }.to output(/Save functionality not yet implemented/).to_stdout
      expect(controller).to have_received(:play_turn)
    end
  end

  describe '#handle_load' do
    it 'outputs not implemented message and continues turn' do
      controller = described_class.new
      allow(controller).to receive(:play_turn)
      
      expect { controller.send(:handle_load) }.to output(/Load functionality not yet implemented/).to_stdout
      expect(controller).to have_received(:play_turn)
    end
  end

  describe '#play_turn' do
    let(:controller) { described_class.new }

    before do
      # Stub external dependencies to isolate behavior
      allow(Chess::Interface).to receive(:announce_turn)
      allow(Chess::Interface).to receive(:announce_invalid_move)
    end

    context 'when user chooses to quit' do
      it 'calls handle_quit' do
        allow(Chess::Interface).to receive(:request_move).and_return({ action: :quit })
        allow(controller).to receive(:handle_quit)
        
        controller.send(:play_turn)
        
        expect(controller).to have_received(:handle_quit)
      end
    end

    context 'when user chooses to save' do
      it 'calls handle_save' do
        allow(Chess::Interface).to receive(:request_move).and_return({ action: :save })
        allow(controller).to receive(:handle_save)
        
        controller.send(:play_turn)
        
        expect(controller).to have_received(:handle_save)
      end
    end

    context 'when user chooses to load' do
      it 'calls handle_load' do
        allow(Chess::Interface).to receive(:request_move).and_return({ action: :load })
        allow(controller).to receive(:handle_load)
        
        controller.send(:play_turn)
        
        expect(controller).to have_received(:handle_load)
      end
    end

    context 'when user provides a valid move' do
      it 'calls handle_move with from and to positions' do
        from_pos = Chess::Position.from_algebraic('e2')
        to_pos = Chess::Position.from_algebraic('e4')
        
        allow(Chess::Interface).to receive(:request_move).and_return({
          action: :move,
          from: from_pos,
          to: to_pos
        })
        allow(controller).to receive(:handle_move)
        
        controller.send(:play_turn)
        
        expect(controller).to have_received(:handle_move).with(from_pos, to_pos)
      end
    end

    context 'when user provides invalid input' do
      it 'announces invalid move and retries turn' do
        allow(Chess::Interface).to receive(:request_move).and_return({ action: :invalid })
        allow(controller).to receive(:play_turn).and_call_original
        # Prevent infinite recursion by stubbing second call
        allow(controller).to receive(:play_turn).and_return(nil)
        
        controller.send(:play_turn)
        
        expect(Chess::Interface).to have_received(:announce_invalid_move)
      end
    end
  end

  describe 'game outcomes' do
    context 'when game ends in checkmate' do
      it 'reports black as winner for fools mate position' do
        # Use real GameState from actual checkmate position
        game = Chess::GameState.from_fen('rnb1kbnr/pppp1ppp/8/4p3/7q/5P2/PPPPP1PP/RNBQKBNR w KQkq - 1 3')
        controller = described_class.new(game)

        expect(controller.state.game_over?).to be true
        expect(controller.state.winner).to eq(Chess::ChessNotation::BLACK_PLAYER)
      end
    end

    context 'when game ends in stalemate' do
      it 'reports no winner for stalemate position' do
        # Use real GameState from actual stalemate position
        game = Chess::GameState.from_fen('8/8/8/8/8/1k6/1P6/1K6 b - - 0 1')
        controller = described_class.new(game)

        expect(controller.state.game_over?).to be true
        expect(controller.state.winner).to be_nil
      end
    end

    context 'when game is in progress' do
      it 'reports game not over for starting position' do
        controller = described_class.new

        expect(controller.state.game_over?).to be false
        expect(controller.state.winner).to be_nil
      end
    end
  end

  describe 'game progression' do
    let(:controller) { described_class.new }

    it 'starts with white to move' do
      expect(controller.state.active_color).to eq(Chess::ChessNotation::WHITE_PLAYER)
    end

    it 'starts with move number of 1' do
      expect(controller.state.full_move_number).to eq(1)
    end

    it 'starts with half move clock at 0' do
      # Half move clock counts moves since last pawn move or capture
      expect(controller.state.half_move_clock).to eq(0)
    end
  end
end
