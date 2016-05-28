require 'securerandom'
require 'cardlet/cards/card'

module Cardlet
  module Cards
    class Question < Card
      attr_accessor :answer, :prompt, :tags, :uuid

      def initialize(json_question)
        super(json_question)
        @prompt = json_question['prompt']
        @answer = json_question['answer']
      end

      def as_json
        {
          'uuid' => @uuid,
          'type' => type,
          'prompt' => @prompt,
          'answer' => @answer,
          'tags' => @tags
        }
      end

      def type
        'question'
      end

      def correct?(response)
        response == @answer
      end
    end
  end
end
