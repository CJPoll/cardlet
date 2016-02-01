require 'spec_helper'

describe Cardlet::Deck do
  deck_name = 'MyDeck'
  default_dir = "#{Dir.home}/.cardlet/decks"

  subject { Cardlet::Deck.new(deck_name) }

  describe 'getters' do
    it 'has a field for the deck name' do
      expect(subject.name).to eq deck_name
    end

    it 'has a field for the deck\'s questions' do
      expect(subject.questions).to eq []
    end
  end

  describe '#as_json' do
    subject { Cardlet::Deck.new(deck_name).as_json }

    it 'encodes to a ruby hash' do
      expect(subject).to be_a Hash
    end

    it 'has a field for the deck name' do
      expect(subject["name"]).to eq deck_name
    end

    it 'has a field for the deck\'s questions' do
      expect(subject["questions"]).to eq []
    end
  end

  describe '#to_json' do
    # This function calls #as_json, and does a JSON.generate on the created
    # hash. Because this function is so simple, only minimal testing is required
    # if we've tested #as_json halfway decently.
    subject { Cardlet::Deck.new(deck_name).to_json }

    it 'encodes to a JSON string' do
      expect(subject).to be_a String
    end
  end

  describe '::from_json' do
    let(:json_hash) {
      {
        "name" => "#{deck_name}",
        "questions" => [
          {
            "type" => "question",
            "prompt" => "What is 2 + 2?",
            "answer" => "4"
          },
          {
            "type" => "question",
            "prompt" => "What is 2 + 3",
            "answer" => "5"
          }
        ]
      }
    }

    subject { Cardlet::Deck.from_json(json_hash) }

    it 'initializes with the name in the json document' do
      expect(subject.name).to eq deck_name
    end

    it 'initializes with the questions in the json document' do
      expect(subject.questions.length).to eq 2
      expect(subject.questions.first).to be_a Cardlet::Question
    end
  end

  describe '#add_card' do
    let(:question) {
      Cardlet::Question.create({
        'type' => 'question',
        'prompt' => 'what is 2+2',
        'answer' => '4'
      })
    }

    it 'adds a card to the given deck' do
      subject.add_question(question)

      expect(subject.questions.length).to be 1
    end
  end
end
