require 'fileutils'

module Cardlet
  module Persistence
    module Deck
      def self.delete(name, directory)
        filename = "#{directory}/#{name}"
        File.delete(filename)
      end

      def self.index(directory)
        Dir.entries(directory).reject do |file|
          file == '.' || file == '..'
        end
      end

      def self.load(name, directory)
        File.read("#{directory}/#{name}")
      end

      def self.write(deck, directory)
        FileUtils.mkdir_p(directory)
        file = File.open("#{directory}/#{deck.name}", 'w')
        file.write(deck.to_json)
      end
    end
  end
end
