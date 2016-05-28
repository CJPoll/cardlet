require 'json'

module Cardlet
  class Deck
    attr_accessor :directory, :name, :cards

    def initialize(deck_name, cards=[])
      @name = deck_name
      @cards = Cardlet::Cards::Card.create(cards)
    end

    def add_card(card)
      @cards << card
      self
    end

    def as_json
      {
        "name" => @name,
        "cards" => @cards.map { |card| card.as_json }
      }
    end

    def cards_matching(tag)
      return @cards unless tag && !(tag.empty?)
      @cards.select do |card|
        card.match?(tag)
      end
    end

    def delete_card(uuid)
      @cards = @cards.reject do |q|
        q.uuid == uuid
      end

      self
    end

    def self.from_json(hash)
      Deck.new(hash["name"], hash["cards"])
    end

    def to_json
      JSON.generate(as_json)
    end

    private

    def find_card(uuid)
      @cards.find do |card|
        card.uuid == uuid
      end
    end
  end
end
