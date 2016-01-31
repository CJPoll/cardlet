module Cardlet
  class Question
    attr_accessor :answer, :prompt, :type

    def initialize(json_question)
      @type = json_question["type"]
      @prompt = json_question["prompt"]
      @answer = json_question["answer"]
    end

    def self.create(input)
      return input.map { |q| Question.new(q) } if input.kind_of?(Array)
      Question.new(input)
    end
  end
end
