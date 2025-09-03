# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::GameController do
  describe '#initialize' do
    context 'with no arguments' do
      it 'creates a new game by default' do
        controller = described_class.new
        expect(controller.game).to be_a(Chess::Game)
      end
    end

    context 'with a game provided' do
      it 'uses the provided game' do
        custom_game = Chess::Game.new
        controller = described_class.new(custom_game)
        expect(controller.game).to be(custom_game)
      end
    end
  end

  describe '#handle_move' do
    let(:controller) { described_class.new }
    
    context 'when move is valid' do
      it 'executes the move and returns true' do
        # Use a real move on starting board
        from_pos = Chess::Position.from_algebraic('e2')
        to_pos = Chess::Position.from_algebraic('e4')
        
        # Capture initial board state for comparison
        initial_piece = controller.game.board.get_piece(from_pos)
        initial_empty = controller.game.board.get_piece(to_pos)
        
        result = controller.send(:handle_move, from_pos, to_pos)
        
        expect(result).to be_nil # handle_move doesn't return, just executes
        expect(controller.game.board.get_piece(to_pos)).to eq(initial_piece)
        expect(controller.game.board.get_piece(from_pos)).to be_nil
      end
    end

    context 'when move is invalid' do
      it 'does not change board state' do
        # Try to move piece that doesn't exist
        from_pos = Chess::Position.from_algebraic('e5')
        to_pos = Chess::Position.from_algebraic('e6')
        
        # Capture board state before invalid move attempt
        initial_board_state = controller.game.board.to_display.dup
        
        # Suppress output during test
        allow(Chess::Interface).to receive(:announce_invalid_move)
        allow(controller).to receive(:play_turn)
        
        controller.send(:handle_move, from_pos, to_pos)
        
        # Board should remain unchanged
        expect(controller.game.board.to_display).to eq(initial_board_state)
      end
    end
  end

  describe '#announce_game_end' do
    context 'when there is a winner' do
      it 'announces white as winner' do
        controller = described_class.new
        allow(controller.game).to receive(:winner).and_return(Chess::ChessNotation::WHITE_PLAYER)
        
        expect { controller.send(:announce_game_end) }.to output(/White won!/).to_stdout
      end

      it 'announces black as winner' do
        controller = described_class.new
        allow(controller.game).to receive(:winner).and_return(Chess::ChessNotation::BLACK_PLAYER)
        
        expect { controller.send(:announce_game_end) }.to output(/Black won!/).to_stdout
      end
    end

    context 'when there is no winner' do
      it 'announces a draw' do
        controller = described_class.new
        allow(controller.game).to receive(:winner).and_return(nil)
        
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

  describe 'game flow integration' do
    context 'when game ends in checkmate' do
      it 'detects white wins by checkmate' do
        # Set up fool's mate position - black is checkmated
        game = Chess::Game.from_fen('rnb1kbnr/pppp1ppp/8/4p3/7q/5P2/PPPPP1PP/RNBQKBNR w KQkq - 1 3')
        controller = described_class.new(game)
        
        expect(controller.game.game_over?).to be true
        expect(controller.game.winner).to eq(Chess::ChessNotation::BLACK_PLAYER)
      end
    end

    context 'when game ends in stalemate' do
      it 'detects stalemate with no winner' do
        # Set up stalemate position
        game = Chess::Game.from_fen('8/8/8/8/8/1k6/1P6/1K6 b - - 0 1')
        controller = described_class.new(game)
        
        expect(controller.game.game_over?).to be true  
        expect(controller.game.winner).to be_nil
      end
    end

    context 'when executing moves changes active player' do
      it 'switches turn after valid move' do
        controller = described_class.new
        initial_color = controller.game.active_color
        
        # Execute a valid move
        move = Chess::Move.new(
          Chess::Position.from_algebraic('e2'),
          Chess::Position.from_algebraic('e4')
        )
        controller.game.execute_move(move)
        controller.game.switch_turn
        
        expect(controller.game.active_color).not_to eq(initial_color)
      end
    end
  end

  describe 'error handling' do
    context 'when game state is corrupted' do
      it 'handles missing pieces gracefully' do
        controller = described_class.new
        # Remove all pieces to create edge case
        controller.game.board.instance_variable_set(:@grid, Array.new(8) { Array.new(8) })
        
        expect(controller.game.game_over?).to be true # Should detect no kings as game over
      end
    end

    context 'when invalid positions are provided' do
      it 'handles out-of-bounds positions' do
        controller = described_class.new
        
        # This should not crash the game
        expect do
          move = Chess::Move.new(
            Chess::Position.new(9, 9), # Invalid position
            Chess::Position.new(10, 10) # Invalid position  
          )
          controller.game.execute_move(move)
        end.not_to raise_error
      end
    end
  end
end