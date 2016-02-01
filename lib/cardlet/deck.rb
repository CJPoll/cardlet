require 'json'

module Cardlet
  class Deck
    attr_accessor :directory, :name, :questions

    def initialize(deck_name, questions=[])
      @name = deck_name
      @questions = Cardlet::Question.create(questions)
    end

    def add_question(question)
      @questions << question
      self
    end

    def as_json
      {
        "name" => @name,
        "questions" => @questions.map { |question| question.as_json }
      }
    end

    def self.from_json(hash)
      Deck.new(hash["name"], hash["questions"])
    end

    def to_json
      JSON.generate(as_json)
    end
  end
end
