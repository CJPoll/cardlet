module Cardlet
  module Cards
    class Card
      def self.create(input)
        types = {
          'question' => Cardlet::Cards::Question,
          'faceted_question' => Cardlet::Cards::FacetedQuestion
        }

        return input.map { |card| types[card['type']].new(card) } if input.kind_of?(Array)
        return types[input['type']].new(input)
      end

      def initialize(json_question)
        @uuid = json_question['uuid'] || SecureRandom.uuid
        @tags = json_question['tags'] || []
      end

      def add_tag(tag)
        @tags << tag
        self
      end

      def match?(tag)
        @tags.include?(tag)
      end

      def correct?(response)
        raise 'Need to override correct?'
      end
    end
  end
end
