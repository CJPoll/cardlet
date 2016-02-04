require 'spec_helper'

describe Cardlet::Question do
  let(:json_question) {
    {
      'type' => 'question',
      'prompt' => 'What is 2 + 2?',
      'answer' => '4',
      'tags' => ['hello', 'world']
    }
  }

  let(:json_questions) {
    [
      {
        'type' => 'question',
        'prompt' => 'What is 2 + 2?',
        'answer' => '4'
      },
      {
        'type' => 'question',
        'prompt' => 'What is 2 + 3?',
        'answer' => '5'
      }
    ]
  }

  let(:questions) { Cardlet::Question.create(json_questions) }

  subject { Cardlet::Question.create(json_question) }

  describe '#new'  do
    context 'single json object' do
      it 'creates a question from a json object' do
        expect(subject).to be_a(Cardlet::Question)
      end

      it 'initializes the type from the json object' do
        expect(subject.type).to eq json_question['type']
      end

      it 'initializes the prompt from the json object' do
        expect(subject.prompt).to eq json_question['prompt']
      end

      it 'initializes the answer from the json object' do
        expect(subject.answer).to eq json_question['answer']
      end

      it 'initializes tags from the json object' do
        expect(subject.tags).to eq ['hello', 'world']
      end

      it 'defaults tags to an empty array' do
        question = Cardlet::Question.create({
          'type' => 'question',
          'prompt' => 'What is 2 + 2?',
          'answer' => '4'
        })

        expect(question.tags).to eq []
      end
    end

    context 'array of question json objects' do
      it 'creates an array of questions from an array of json objects' do
        expect(questions).to be_a Array
        expect(questions.count).to eq 2
        expect(questions.first).to be_a Cardlet::Question
        expect(questions.last).to be_a Cardlet::Question
      end

      it 'initializes the questions with the correspondind input values' do
        expect(questions.first.answer).to eq '4'
        expect(questions.last.answer).to eq '5'
      end
    end
  end

  describe '#add_tag' do
    it 'returns the card' do
      expect(subject.add_tag('hi')).to be_a Cardlet::Question
    end

    it 'adds a tag to a question' do
      expect(subject.add_tag('hi').tags).to include 'hi'
    end
  end
end
