require 'spec_helper'

describe Cardlet::Deck do
  deck_name = 'MyDeck'
  default_dir = "#{Dir.home}/.cardlet/decks"

  let(:question_hash) {
    {
      "uuid" => "27f164d7-0993-42a5-b5b7-24302f89814b",
      "type" => "question",
      "prompt" => "what is your quest?",
      "answer" => "to find the holy grail",
      "tags" => []
    }
  }

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
    subject { Cardlet::Deck.new(deck_name).add_question(Cardlet::Question.new(question_hash)).as_json }

    it 'encodes to a ruby hash' do
      expect(subject).to be_a Hash
    end

    it 'has a field for the deck name' do
      expect(subject["name"]).to eq deck_name
    end

    it 'has a field for the deck\'s questions' do
      expect(subject["questions"]).to eq [question_hash]
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
      expect(subject.questions.first.answer).to eq "4"
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

    subject { Cardlet::Deck.new(deck_name).add_question(question) }

    it 'adds a card to the given deck' do
      expect(subject.questions.length).to be 1
    end

    it 'returns itself for chaining' do
      expect(subject).to be_a Cardlet::Deck
    end
  end

  describe '#delete_card' do
    let(:question) { Cardlet::Question.new(question_hash) }

    subject { Cardlet::Deck.new(deck_name).add_question(question) }

    it 'removes a card from the deck' do
      expect(subject.questions.count).to eq 1
      expect(subject.delete_question(question.uuid).questions).to eq []
    end

    it 'returns the deck' do
      expect(subject.delete_question(question.uuid)).to be_a Cardlet::Deck
    end
  end

  describe '#cards_matching' do
    let(:json_hash) {
      {
        "name" => "#{deck_name}",
        "questions" => [
          {
            "uuid" => 1,
            "type" => "question",
            "prompt" => "What is 2 + 2?",
            "answer" => "4",
            "tags" => ['hello']
          },
          {
            "uuid" => 2,
            "type" => "question",
            "prompt" => "What is 2 + 3",
            "answer" => "5",
            "tags" => ['world']
          }
        ]
      }
    }

    subject { Cardlet::Deck.from_json(json_hash) }

    it 'only includes questions that match the tag' do

      results = subject.cards_matching('world')
      expect(results.length).to eq 1
      expect(results.first.uuid).to eq 2
    end

    it 'returns all questions if tag is nil' do
      results = subject.cards_matching(nil)
      expect(results.length).to eq 2
    end

    it 'returns all questions if tag is an empty string' do
      results = subject.cards_matching('')
      expect(results.length).to eq 2
    end
  end
end
