# frozen_string_literal: true

require_relative '../../../lib/chess'

describe Chess::GameSerializer do
  subject(:serializer) { described_class.new }
  
  let(:game) { Chess::Game.new }
  let(:filename) { 'test_game' }
  let(:save_directory) { 'saved_games' }
  
  after do
    # Clean up any created test files
    FileUtils.rm_rf(save_directory) if Dir.exist?(save_directory)
  end

  describe '#save_game' do
    context 'when saving a valid game' do
      it 'returns success with filename and path' do
        result = serializer.save_game(game, filename)
        
        expect(result[:success]).to be true
        expect(result[:filename]).to eq(filename)
        expect(result[:path]).to include("#{filename}.json")
      end
      
      it 'creates the save directory if it does not exist' do
        FileUtils.rm_rf(save_directory) if Dir.exist?(save_directory)
        
        serializer.save_game(game, filename)
        
        expect(Dir.exist?(save_directory)).to be true
      end
      
      it 'creates a JSON file with game data' do
        serializer.save_game(game, filename)
        file_path = File.join(save_directory, "#{filename}.json")
        
        expect(File.exist?(file_path)).to be true
        
        json_content = File.read(file_path)
        parsed_data = JSON.parse(json_content, symbolize_names: true)
        
        expect(parsed_data).to have_key(:fen)
        expect(parsed_data).to have_key(:move_history)
        expect(parsed_data).to have_key(:saved_at)
      end
      
      it 'sanitizes filename with special characters' do
        special_filename = 'test game!@#$%^&*()'
        result = serializer.save_game(game, special_filename)
        
        expect(result[:success]).to be true
        expect(result[:path]).to include('test_game___________.json')
      end
    end
    
    context 'when an error occurs during saving' do
      it 'returns failure with error message' do
        allow(File).to receive(:write).and_raise(StandardError.new('Permission denied'))
        
        result = serializer.save_game(game, filename)
        
        expect(result[:success]).to be false
        expect(result[:error]).to eq('Permission denied')
      end
    end
  end

  describe '#load_game' do
    context 'when loading an existing valid file' do
      let(:game_data) do
        {
          fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
          move_history: {
            moves: ['e2e4', 'e7e5'],
            past_positions: []
          },
          saved_at: Time.now.iso8601
        }
      end
      
      before do
        FileUtils.mkdir_p(save_directory)
        File.write(File.join(save_directory, "#{filename}.json"), JSON.pretty_generate(game_data))
      end
      
      it 'returns success with loaded game' do
        result = serializer.load_game(filename)
        
        expect(result[:success]).to be true
        expect(result[:filename]).to eq(filename)
        expect(result[:game]).to be_a(Chess::Game)
      end
      
      it 'loads game with correct FEN position' do
        result = serializer.load_game(filename)
        loaded_game = result[:game]
        
        expect(loaded_game.to_fen).to eq(game_data[:fen])
      end
    end
    
    context 'when file does not exist' do
      it 'returns failure with file not found error' do
        result = serializer.load_game('nonexistent_file')
        
        expect(result[:success]).to be false
        expect(result[:error]).to eq('File not found')
      end
    end
    
    context 'when file contains invalid JSON' do
      before do
        FileUtils.mkdir_p(save_directory)
        File.write(File.join(save_directory, "#{filename}.json"), 'invalid json content')
      end
      
      it 'returns failure with invalid JSON error' do
        result = serializer.load_game(filename)
        
        expect(result[:success]).to be false
        expect(result[:error]).to eq('Invalid JSON format')
      end
    end
    
    context 'when an unexpected error occurs' do
      before do
        FileUtils.mkdir_p(save_directory)
        File.write(File.join(save_directory, "#{filename}.json"), '{}')
      end
      
      it 'returns failure with error message' do
        allow(Chess::Game).to receive(:from_fen).and_raise(StandardError.new('Invalid FEN'))
        
        result = serializer.load_game(filename)
        
        expect(result[:success]).to be false
        expect(result[:error]).to eq('Invalid FEN')
      end
    end
  end

  describe '.save_game' do
    it 'delegates to instance method' do
      expect_any_instance_of(described_class).to receive(:save_game).with(game, filename)
      described_class.save_game(game, filename)
    end
  end

  describe '.load_game' do
    it 'delegates to instance method' do
      expect_any_instance_of(described_class).to receive(:load_game).with(filename)
      described_class.load_game(filename)
    end
  end

  describe 'integration with real game states' do
    context 'when saving and loading a complete game cycle' do
      it 'preserves game state through save and load cycle' do
        # Create a game with some moves
        original_game = Chess::Game.new
        # Note: Not making actual moves as that would require complex setup
        # Instead testing with the initial position which is sufficient for behavior testing
        
        # Save the game
        save_result = serializer.save_game(original_game, filename)
        expect(save_result[:success]).to be true
        
        # Load the game
        load_result = serializer.load_game(filename)
        expect(load_result[:success]).to be true
        
        loaded_game = load_result[:game]
        
        # Verify the loaded game has the same state
        expect(loaded_game.to_fen).to eq(original_game.to_fen)
      end
    end
  end
end