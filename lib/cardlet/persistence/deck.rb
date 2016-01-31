require 'byebug'
require 'fileutils'

module Cardlet
  module Persistence
    module Deck
      def self.write(deck, directory)
        FileUtils.mkdir_p(directory)
        file = File.open("#{directory}/#{deck.name}", 'w')
        file.write(deck.to_json)
      end
    end
  end
end
