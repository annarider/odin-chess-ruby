# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::GameController do
  let(:start_board) { Chess::Board.start_positions }
  let(:state) { Chess::GameState.new }
  subject(:controller) { described_class.new }

  describe '#initialize' do
    context 'with no arguments' do
      it 'creates a new game by default' do
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
    context 'when move is valid' do
      it 'sends play_move message to game state instance' do
        # Arrange
        from_pos = Chess::Position.from_algebraic('e2')
        to_pos = Chess::Position.from_algebraic('e4')
        allow(controller.state).to receive(:play_move).and_return(true)
        allow(Chess::Display).to receive(:show_board)
        # Act
        controller.send(:handle_move, from_pos, to_pos)
        # Assert
        expect(controller.state).to have_received(:play_move)
      end

      it 'changes the active player' do
        # Test behavior: valid moves should switch turns
        from_pos = Chess::Position.from_algebraic('e2')
        to_pos = Chess::Position.from_algebraic('e4')

        expect { controller.send(:handle_move, from_pos, to_pos) }
          .to change(controller.state, :active_color)
          .from(Chess::ChessNotation::WHITE_PLAYER)
          .to(Chess::ChessNotation::BLACK_PLAYER)
      end

      it 'does not increases the full move number after white plays' do
        # Test behavior: valid moves increment game progress
        from_pos = Chess::Position.from_algebraic('e2')
        to_pos = Chess::Position.from_algebraic('e4')

        expect { controller.send(:handle_move, from_pos, to_pos) }
          .to change(controller.state, :full_move_number).by(0)
      end

      it 'increases the full move number by 1 after black plays' do
        # Test behavior: complete move cycle (white + black) increments counter
        # Set up: White moves first
        white_from = Chess::Position.from_algebraic('e2')
        white_to = Chess::Position.from_algebraic('e4')
        controller.send(:handle_move, white_from, white_to)
        
        # Test: Black's move should increment the full move counter
        black_from = Chess::Position.from_algebraic('e7')
        black_to = Chess::Position.from_algebraic('e5')
        expect { controller.send(:handle_move, black_from, black_to) }
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
    before do
      allow(Chess::Interface).to receive(:confirm_quit).and_return('y')
    end
    it 'displays farewell message and exits program' do
      expect { controller.send(:handle_quit) }
        .to output(/Thanks for playing!/).to_stdout
        .and raise_error(SystemExit)
    end
  end

  describe '#handle_save' do
    let(:controller) { described_class.new }
    
    before do
      allow(controller).to receive(:play_turn) # Prevent recursion
    end

    context 'when save succeeds' do
      it 'outputs success message with filename' do
        allow(Chess::Interface).to receive(:request_save_filename).and_return('test_game')
        allow(Chess::GameSerializer).to receive(:save_game).and_return({
          success: true,
          filename: 'test_game'
        })

        expect { controller.send(:handle_save) }
          .to output(/Game saved successfully as 'test_game.json'/).to_stdout
      end
    end

    context 'when save fails' do
      it 'outputs failure message with error' do
        allow(Chess::Interface).to receive(:request_save_filename).and_return('invalid')
        allow(Chess::GameSerializer).to receive(:save_game).and_return({
          success: false,
          error: 'Permission denied'
        })

        expect { controller.send(:handle_save) }
          .to output(/Failed to save game: Permission denied/).to_stdout
      end
    end

    context 'when user provides filename' do
      it 'passes filename to GameSerializer' do
        allow(Chess::Interface).to receive(:request_save_filename).and_return('my_game')
        allow(Chess::GameSerializer).to receive(:save_game).and_return({
          success: true,
          filename: 'my_game'
        })

        controller.send(:handle_save)

        expect(Chess::GameSerializer).to have_received(:save_game)
          .with(controller.state, 'my_game')
      end
    end
  end

  describe '#handle_load' do
    let(:initial_state) { controller.state }

    before do
      allow(controller).to receive(:play_turn) # Prevent recursion
    end

    context 'when load succeeds' do
      let(:loaded_state) { Chess::GameState.new }
      before do
        allow(Chess::Interface).to receive(:request_load_filename).and_return('saved_game')
        allow(Chess::GameSerializer).to receive(:load_game).and_return({
          success: true,
          filename: 'saved_game',
          state: loaded_state
        })
        allow(Chess::Display).to receive(:show_board)
      end
      it 'outputs success message with filename' do
        expect { controller.send(:handle_load) }
          .to output(/Game loaded successfully from 'saved_game.json'/).to_stdout
      end

      it 'replaces game state with loaded state' do
        expect { controller.send(:handle_load) }
          .to change(controller, :state).from(initial_state).to(loaded_state)
      end

      it 'displays the loaded board' do
        controller.send(:handle_load)
        expect(Chess::Display).to have_received(:show_board).with(loaded_state.board.to_display)
      end
    end

    context 'when load fails' do
      before do
        allow(Chess::Interface).to receive(:request_load_filename).and_return('nonexistent')
        allow(Chess::GameSerializer).to receive(:load_game).and_return({
          success: false,
          error: 'File not found'
        })
      end
      it 'outputs failure message with error' do
        expect { controller.send(:handle_load) }
          .to output(/Failed to load game: File not found/).to_stdout
      end

      it 'does not change game state when load fails' do
        expect { controller.send(:handle_load) }
          .not_to change(controller, :state)
      end
    end

    context 'when user provides empty filename' do
      it 'does not attempt to load and does not change state' do
        # Arrange: set up stubs and spies
        allow(Chess::Interface).to receive(:request_load_filename).and_return('')
        allow(Chess::GameSerializer).to receive(:load_game)
        # Act: perform the action
        expect { controller.send(:handle_load) }
          .not_to change(controller, :state)
        # Assert: observe the expected outcome
        expect(Chess::GameSerializer).not_to have_received(:load_game)
      end
    end

    context 'when user provides filename' do
      it 'passes filename to GameSerializer' do
        loaded_state = Chess::GameState.new
        allow(Chess::Interface).to receive(:request_load_filename).and_return('my_saved_game')
        allow(Chess::GameSerializer).to receive(:load_game).and_return({
          success: true,
          filename: 'my_saved_game',
          state: loaded_state
        })
        allow(Chess::Display).to receive(:show_board)

        controller.send(:handle_load)

        expect(Chess::GameSerializer).to have_received(:load_game).with('my_saved_game')
      end
    end
  end

  describe '#play_turn' do
    let(:controller) { described_class.new }

    before do
      # Only stub external UI dependencies, not internal behavior
      allow(Chess::Interface).to receive(:announce_turn)
      allow(Chess::Interface).to receive(:announce_invalid_move)
      allow(Chess::Display).to receive(:show_board)
    end

    context 'when user makes a valid move' do
      it 'changes the active player' do
        from_pos = Chess::Position.from_algebraic('e2')
        to_pos = Chess::Position.from_algebraic('e4')
        
        allow(Chess::Interface).to receive(:request_move).and_return({
          action: :move,
          from: from_pos,
          to: to_pos
        })
        
        expect { controller.send(:play_turn) }
          .to change(controller.state, :active_color)
          .from(Chess::ChessNotation::WHITE_PLAYER)
          .to(Chess::ChessNotation::BLACK_PLAYER)
      end
    end

    context 'when user provides invalid input' do
      it 'does not change game state' do
        allow(Chess::Interface).to receive(:request_move).and_return({ action: :invalid })
        allow(controller).to receive(:play_turn).and_return(nil) # Prevent recursion
        
        expect { controller.send(:play_turn) }
          .not_to change(controller.state, :active_color)
      end
    end

    context 'when user quits' do
      before do
        allow(Chess::Interface).to receive(:confirm_quit).and_return('y')
      end
      it 'exits the program' do
        allow(Chess::Interface).to receive(:request_move).and_return({ action: :quit })
        
        expect { controller.send(:play_turn) }
          .to output(/Thanks for playing!/).to_stdout
          .and raise_error(SystemExit)
      end
    end

    context 'when user requests save' do
      it 'calls handle_save and continues' do
        allow(Chess::Interface).to receive(:request_move).and_return({ action: :save })
        allow(controller).to receive(:handle_save).and_return(nil) # Prevent recursion from handle_save
        
        controller.send(:play_turn)
        
        expect(controller).to have_received(:handle_save)
      end
    end

    context 'when user requests load' do
      it 'displays not implemented message and continues' do
        allow(Chess::Interface).to receive(:request_move).and_return({ action: :load })
        allow(controller).to receive(:play_turn).and_return(nil) # Prevent recursion
        
        expect { controller.send(:play_turn) }
          .to output(/Load functionality not yet implemented/).to_stdout
      end
    end
  end

  describe 'game outcomes' do
    context 'when game ends in checkmate' do
      it 'detects checkmate correctly' do
        # Use real GameState from actual checkmate position
        game = Chess::GameState.from_fen('rnb1kbnr/pppp1ppp/8/4p3/7q/5P2/PPPPP1PP/RNBQKBNR w KQkq - 1 3')
        controller = described_class.new(game)

        expect(controller.state.game_over?).to be true
      end
      
      it 'identifies the winner correctly' do
        game = Chess::GameState.from_fen('rnb1kbnr/pppp1ppp/8/4p3/7q/5P2/PPPPP1PP/RNBQKBNR w KQkq - 1 3')
        controller = described_class.new(game)

        expect(controller.state.winner).to eq(Chess::ChessNotation::BLACK_PLAYER)
      end
    end

    context 'when game ends in a draw due to a stalemate' do
      let(:game) { Chess::GameState.from_fen('8/8/8/8/8/6q1/5k2/7K w - - 0 1') }
      it 'returns game over correctly' do
        # Arrange stalemate position
        controller = described_class.new(game)

        expect(controller.state.game_over?).to be true
      end
      
      it 'reports no winner for stalemate' do
        controller = described_class.new(game)

        expect(controller.state.winner).to be_nil
      end
    end

    context 'when game ends in a draw due to dead position ' do
      let(:game) { Chess::GameState.from_fen('8/8/8/8/8/1k6/1P6/1K6 b - - 0 1') }
      it 'returns game over correctly' do
        # Arrange real dead position board position
        controller = described_class.new(game)

        expect(controller.state.game_over?).to be true
      end
      
      it 'reports no winner for dead position' do
        controller = described_class.new(game)

        expect(controller.state.winner).to be_nil
      end
    end

    context 'when game is in progress' do
      it 'detects ongoing game correctly' do
        controller = described_class.new

        expect(controller.state.game_over?).to be false
      end
      
      it 'reports no winner for ongoing game' do
        controller = described_class.new

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
