require 'spec_helper'

describe Cardlet::Cards::Question do
  let(:json_question) {
    {
      'uuid' => 'e614405d-ce16-47ce-88b2-6d54ddc3b228',
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

  let(:questions) { Cardlet::Cards::Card.create(json_questions) }

  subject { Cardlet::Cards::Card.create(json_question) }

  describe '#new'  do
    context 'single json object' do
      it 'creates a question from a json object' do
        expect(subject).to be_a(Cardlet::Cards::Question)
      end

      it 'initializes with the given uuid' do
        expect(subject.uuid).to eq 'e614405d-ce16-47ce-88b2-6d54ddc3b228'
      end
 
      it 'generates a uuid if none is given' do
        question = Cardlet::Cards::Card.create(json_question.without('uuid'))
        expect(question.uuid).to match /[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/
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
        question = Cardlet::Cards::Card.create({
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
        expect(questions.first).to be_a Cardlet::Cards::Question
        expect(questions.last).to be_a Cardlet::Cards::Question
      end

      it 'initializes the questions with the correspondind input values' do
        expect(questions.first.answer).to eq '4'
        expect(questions.last.answer).to eq '5'
      end
    end
  end

  describe '#add_tag' do
    it 'returns the card' do
      expect(subject.add_tag('hi')).to be_a Cardlet::Cards::Question
    end

    it 'adds a tag to a question' do
      expect(subject.add_tag('hi').tags).to include 'hi'
    end
  end

  describe '#match?' do
    it 'knows when a card matches a tag' do
      expect(subject.match?('hello')).to be true
    end

    it 'knows when a card does not match a given tag' do
      expect(subject.match?('wat?')).to be false
    end
  end
end
