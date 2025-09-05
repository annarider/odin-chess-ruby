# frozen_string_literal: true

require_relative '../../lib/chess'

# Integration test for fool's mate through GameController#play
# Tests the complete game flow from user input to checkmate
# Following Sandi Metz principles:
# - Tests behavior, not implementation
# - Uses real objects, stubs only external dependencies (Interface)
# - Tests from user's perspective (actual game play)
# - Focuses on outcomes (checkmate, game over, winner)
describe Chess::GameController do
  describe 'fool\'s mate integration' do
    subject(:controller) { described_class.new }

    before do
      # Stub external UI dependencies to prevent actual I/O during test
      allow(Chess::Interface).to receive(:welcome)
      allow(Chess::Interface).to receive(:announce_turn)
      allow(Chess::Display).to receive(:show_board)
    end

    it 'plays through fool\'s mate and ends in checkmate for black' do
      # Arrange: Set up the sequence of user inputs for fool's mate
      allow(Chess::Interface).to receive(:request_move).and_return(
        { action: :move, from: Chess::Position.from_algebraic('f2'), to: Chess::Position.from_algebraic('f3') },
        { action: :move, from: Chess::Position.from_algebraic('e7'), to: Chess::Position.from_algebraic('e5') },
        { action: :move, from: Chess::Position.from_algebraic('g2'), to: Chess::Position.from_algebraic('g4') },
        { action: :move, from: Chess::Position.from_algebraic('d8'), to: Chess::Position.from_algebraic('h4') }
      )

      # Act: Start the game (it will end after fool's mate)
      controller.play

      # Assert: Verify the game ended in checkmate with black as winner
      expect(controller.state.game_over?).to be true
      expect(controller.state.winner).to eq Chess::ChessNotation::BLACK_PLAYER
      # Verify it's specifically checkmate
      white_checkmated = Chess::CheckmateDetector.checkmate?(
        controller.state.board, Chess::ChessNotation::WHITE_PLAYER
      )
      expect(white_checkmated).to be true
      expect(Chess::StalemateValidator.stalemate?(controller.state.board, Chess::ChessNotation::WHITE_PLAYER)).to be false
    end

    it 'maintains correct game state during fool\'s mate sequence' do
      # Set up inputs
      allow(Chess::Interface).to receive(:request_move).and_return(
        { action: :move, from: Chess::Position.from_algebraic('f2'), to: Chess::Position.from_algebraic('f3') },
        { action: :move, from: Chess::Position.from_algebraic('e7'), to: Chess::Position.from_algebraic('e5') },
        { action: :move, from: Chess::Position.from_algebraic('g2'), to: Chess::Position.from_algebraic('g4') },
        { action: :move, from: Chess::Position.from_algebraic('d8'), to: Chess::Position.from_algebraic('h4') }
      )

      # Verify initial state
      expect(controller.state.active_color).to eq Chess::ChessNotation::WHITE_PLAYER

      # Play the game
      controller.play

      # Verify final state - after fool's mate (4 half-moves), we should have 3 full moves
      # Start=1, after Black's 1st move=2, after Black's 2nd move=3
      expect(controller.state.full_move_number).to eq 3
      expect(controller.state.active_color).to eq Chess::ChessNotation::WHITE_PLAYER # White checkmated
    end

    it 'announces black as winner after fool\'s mate' do
      # Set up inputs
      allow(Chess::Interface).to receive(:request_move).and_return(
        { action: :move, from: Chess::Position.from_algebraic('f2'), to: Chess::Position.from_algebraic('f3') },
        { action: :move, from: Chess::Position.from_algebraic('e7'), to: Chess::Position.from_algebraic('e5') },
        { action: :move, from: Chess::Position.from_algebraic('g2'), to: Chess::Position.from_algebraic('g4') },
        { action: :move, from: Chess::Position.from_algebraic('d8'), to: Chess::Position.from_algebraic('h4') }
      )

      # Test that the correct winner announcement is made
      expect { controller.play }.to output(/Black won!/).to_stdout
    end
  end
end
