# frozen_string_literal: true

require 'json'
require 'fileutils'

module Chess
  # GameSerializer handles saving and loading game states
  # to and from JSON files following the Single Responsibility Principle
  class GameSerializer
    attr_reader :state, :filename

    SAVE_DIRECTORY = 'saved_games'

    def self.save_game(...)
      new(...).save_game
    end

    def self.load_game(...)
      new(...).load_game
    end

    def initialize(state = nil, filename)
      @state = state
      @filename = filename
      ensure_save_directory_exists
    end

    def save_game
      file_path = build_file_path
      game_data = serialize_game
      
      File.write(file_path, JSON.pretty_generate(game_data))
      { success: true, filename: filename, path: file_path }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    def load_game
      file_path = build_file_path
      return { success: false, error: 'File not found' } unless File.exist?(file_path)

      json_data = File.read(file_path)
      game_data = JSON.parse(json_data, symbolize_names: true)
      state = deserialize_game(game_data)
      
      { success: true, state: state, filename: filename }
    rescue JSON::ParserError
      { success: false, error: 'Invalid JSON format' }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    private

    def ensure_save_directory_exists
      FileUtils.mkdir_p(SAVE_DIRECTORY) unless Dir.exist?(SAVE_DIRECTORY)
    end

    def build_file_path
      sanitized_filename = sanitize_filename
      File.join(SAVE_DIRECTORY, "#{sanitized_filename}.json")
    end

    def sanitize_filename
      filename.gsub(/[^\w\-_]/, '_')
    end

    def serialize_game
      {
        fen: state.to_fen,
        move_history: serialize_move_history(state.move_history),
        saved_at: Time.now.iso8601
      }
    end

    def serialize_move_history(move_history)
      {
        moves: move_history.move_history.map(&:to_s),
        past_positions: move_history.past_positions
      }
    end

    def deserialize_game(game_data)
      Game.from_fen(game_data[:fen])
    end
  end
end
