# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::Interface do
  describe '.welcome' do
    it 'displays welcome message' do
      expected_output = <<~WELCOME
        ♔♟️ Welcome to Chess. You will play a Chess game in the console.
        We will have 2 players represented by color, white and black.
        As with traditional chess games, white moves first.
      WELCOME

      expect { described_class.welcome }.to output(expected_output).to_stdout
    end
  end

  describe '.request_move' do
    context 'when user enters quit commands' do
      it 'returns quit action for "quit"' do
        allow(described_class).to receive(:gets).and_return('quit')

        result = described_class.request_move

        expect(result[:action]).to eq(:quit)
      end

      it 'returns quit action for "q"' do
        allow(described_class).to receive(:gets).and_return('q')

        result = described_class.request_move

        expect(result[:action]).to eq(:quit)
      end

      it 'returns quit action for "QUIT" (case insensitive)' do
        allow(described_class).to receive(:gets).and_return('QUIT')

        result = described_class.request_move

        expect(result[:action]).to eq(:quit)
      end
    end

    context 'when user enters save commands' do
      it 'returns save action for "save"' do
        allow(described_class).to receive(:gets).and_return('save')

        result = described_class.request_move

        expect(result[:action]).to eq(:save)
      end

      it 'returns save action for "s"' do
        allow(described_class).to receive(:gets).and_return('s')

        result = described_class.request_move

        expect(result[:action]).to eq(:save)
      end
    end

    context 'when user enters load commands' do
      it 'returns load action for "load"' do
        allow(described_class).to receive(:gets).and_return('load')

        result = described_class.request_move

        expect(result[:action]).to eq(:load)
      end

      it 'returns load action for "l"' do
        allow(described_class).to receive(:gets).and_return('l')

        result = described_class.request_move

        expect(result[:action]).to eq(:load)
      end
    end

    context 'when user enters valid chess moves' do
      it 'returns move action with positions for space-separated move' do
        allow(described_class).to receive(:gets).and_return('e2 e4')

        result = described_class.request_move

        expect(result[:action]).to eq(:move)
        expect(result[:from]).to be_a(Chess::Position)
        expect(result[:to]).to be_a(Chess::Position)
        expect(result[:from].to_algebraic).to eq('e2')
        expect(result[:to].to_algebraic).to eq('e4')
        expect(result[:raw_input]).to eq('e2 e4')
      end

      it 'returns move action with positions for dash-separated move' do
        allow(described_class).to receive(:gets).and_return('e2-e4')

        result = described_class.request_move

        expect(result[:action]).to eq(:move)
        expect(result[:from].to_algebraic).to eq('e2')
        expect(result[:to].to_algebraic).to eq('e4')
        expect(result[:raw_input]).to eq('e2-e4')
      end

      it 'handles moves with extra whitespace' do
        allow(described_class).to receive(:gets).and_return('  e2   e4  ')

        result = described_class.request_move

        expect(result[:action]).to eq(:move)
        expect(result[:from].to_algebraic).to eq('e2')
        expect(result[:to].to_algebraic).to eq('e4')
      end

      it 'handles uppercase moves' do
        allow(described_class).to receive(:gets).and_return('E2 E4')

        result = described_class.request_move

        expect(result[:action]).to eq(:move)
        expect(result[:from].to_algebraic).to eq('e2')
        expect(result[:to].to_algebraic).to eq('e4')
      end
    end

    context 'when user enters invalid input' do
      it 'returns invalid action for incomplete move' do
        allow(described_class).to receive(:gets).and_return('e2')

        result = described_class.request_move

        expect(result[:action]).to eq(:invalid)
      end

      it 'returns invalid action for too many parts' do
        allow(described_class).to receive(:gets).and_return('e2 e4 e5')

        result = described_class.request_move

        expect(result[:action]).to eq(:invalid)
      end

      it 'returns invalid action for invalid square notation' do
        allow(described_class).to receive(:gets).and_return('z9 a1')

        result = described_class.request_move

        expect(result[:action]).to eq(:invalid)
      end

      it 'returns invalid action for non-chess input' do
        allow(described_class).to receive(:gets).and_return('hello world')

        result = described_class.request_move

        expect(result[:action]).to eq(:invalid)
      end
    end

    it 'prompts user for input' do
      allow(described_class).to receive(:gets).and_return('quit')
      expected_prompt = "Enter your move (e.g., 'e2 e4' or 'e2-e4'), or type 'quit', 'save', or 'load':"

      expect { described_class.request_move }.to output(/#{Regexp.escape(expected_prompt)}/).to_stdout
    end
  end

  describe '.announce_turn' do
    it 'announces white player turn' do
      expected_output = "White's turn.\n"

      expect { described_class.announce_turn(Chess::ChessNotation::WHITE_PLAYER) }.to output(expected_output).to_stdout
    end

    it 'announces black player turn' do
      expected_output = "Black's turn.\n"

      expect { described_class.announce_turn(Chess::ChessNotation::BLACK_PLAYER) }.to output(expected_output).to_stdout
    end
  end

  describe '.announce_check' do
    it 'announces white is in check' do
      expected_output = "White is in check!\n"

      expect { described_class.announce_check(Chess::ChessNotation::WHITE_PLAYER) }.to output(expected_output).to_stdout
    end

    it 'announces black is in check' do
      expected_output = "Black is in check!\n"

      expect { described_class.announce_check(Chess::ChessNotation::BLACK_PLAYER) }.to output(expected_output).to_stdout
    end
  end

  describe '.announce_invalid_move' do
    it 'displays invalid move message' do
      expected_output = "❌ Invalid move. Please try again.\n"

      expect { described_class.announce_invalid_move }.to output(expected_output).to_stdout
    end
  end

  describe '.request_save_filename' do
    context 'when user provides a filename' do
      it 'returns the provided filename' do
        allow(described_class).to receive(:gets).and_return('my_game')

        result = described_class.request_save_filename

        expect(result).to eq('my_game')
      end

      it 'strips whitespace from filename' do
        allow(described_class).to receive(:gets).and_return('  my_game  ')

        result = described_class.request_save_filename

        expect(result).to eq('my_game')
      end
    end

    context 'when user provides empty filename' do
      it 'returns timestamp-based filename' do
        allow(described_class).to receive(:gets).and_return('')
        allow(Time).to receive(:now).and_return(Time.new(2023, 12, 25, 14, 30, 45))

        result = described_class.request_save_filename

        expect(result).to eq('chess_game_20231225_143045')
      end
    end

    it 'prompts user for filename' do
      allow(described_class).to receive(:gets).and_return('test')
      expected_prompt = "Enter filename to save (without extension):\n"

      expect { described_class.request_save_filename }.to output(expected_prompt).to_stdout
    end
  end

  describe '.request_load_filename' do
    it 'returns the provided filename' do
      allow(described_class).to receive(:gets).and_return('saved_game')

      result = described_class.request_load_filename

      expect(result).to eq('saved_game')
    end

    it 'strips whitespace from filename' do
      allow(described_class).to receive(:gets).and_return('  saved_game  ')

      result = described_class.request_load_filename

      expect(result).to eq('saved_game')
    end

    it 'prompts user for filename' do
      allow(described_class).to receive(:gets).and_return('test')
      expected_prompt = "Enter filename to load (without extension):\n"

      expect { described_class.request_load_filename }.to output(expected_prompt).to_stdout
    end
  end

  describe '.confirm_quit' do
    context 'when user confirms quit' do
      it 'returns true for "y"' do
        allow(described_class).to receive(:gets).and_return('y')

        result = described_class.confirm_quit

        expect(result).to be true
      end

      it 'returns true for "yes"' do
        allow(described_class).to receive(:gets).and_return('yes')

        result = described_class.confirm_quit

        expect(result).to be true
      end

      it 'returns true for "Y" (case insensitive)' do
        allow(described_class).to receive(:gets).and_return('Y')

        result = described_class.confirm_quit

        expect(result).to be true
      end

      it 'returns true for "YES" (case insensitive)' do
        allow(described_class).to receive(:gets).and_return('YES')

        result = described_class.confirm_quit

        expect(result).to be true
      end
    end

    context 'when user does not confirm quit' do
      it 'returns false for "n"' do
        allow(described_class).to receive(:gets).and_return('n')

        result = described_class.confirm_quit

        expect(result).to be false
      end

      it 'returns false for "no"' do
        allow(described_class).to receive(:gets).and_return('no')

        result = described_class.confirm_quit

        expect(result).to be false
      end

      it 'returns false for any other input' do
        allow(described_class).to receive(:gets).and_return('maybe')

        result = described_class.confirm_quit

        expect(result).to be false
      end
    end

    it 'prompts user for confirmation' do
      allow(described_class).to receive(:gets).and_return('y')
      expected_prompt = "Are you sure you want to quit? (y/n)\n"

      expect { described_class.confirm_quit }.to output(expected_prompt).to_stdout
    end
  end

  describe 'input validation' do
    context 'when validating square notation' do
      it 'accepts valid squares from a1 to h8' do
        allow(described_class).to receive(:gets).and_return('a1 h8')

        result = described_class.request_move

        expect(result[:action]).to eq(:move)
      end

      it 'rejects squares with invalid files' do
        allow(described_class).to receive(:gets).and_return('i1 a1')

        result = described_class.request_move

        expect(result[:action]).to eq(:invalid)
      end

      it 'rejects squares with invalid ranks' do
        allow(described_class).to receive(:gets).and_return('a9 a1')

        result = described_class.request_move

        expect(result[:action]).to eq(:invalid)
      end

      it 'rejects squares with wrong length' do
        allow(described_class).to receive(:gets).and_return('a11 b2')

        result = described_class.request_move

        expect(result[:action]).to eq(:invalid)
      end
    end
  end
end
