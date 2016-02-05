require 'securerandom'

module Cardlet
  class Question
    attr_accessor :answer, :prompt, :tags, :type, :uuid

    def initialize(json_question)
      @uuid = json_question['uuid'] || SecureRandom.uuid
      @type = json_question['type']
      @prompt = json_question['prompt']
      @answer = json_question['answer']
      @tags = json_question['tags'] || []
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
        'uuid' => @uuid,
        'type' => @type,
        'prompt' => @prompt,
        'answer' => @answer,
        'tags' => @tags
      }
    end

    def match?(tag)
      @tags.include?(tag)
    end
  end
end
