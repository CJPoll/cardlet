module Cardlet
  class Question
    attr_accessor :answer, :prompt, :tags, :type

    def initialize(json_question)
      @type = json_question["type"]
      @prompt = json_question["prompt"]
      @answer = json_question["answer"]
      @tags = json_question["tags"] || []
    end

    def self.create(input)
      return input.map { |q| Question.new(q) } if input.kind_of?(Array)
      Question.new(input)
    end

    def add_tag(tag)
      @tags << tag
      self
    end

    def as_json
      {
        "type" => @type,
        "prompt" => @prompt,
        "answer" => @answer,
        "tags" => @tags
      }
    end
  end
end
