require './lib/cardlet/hash'
require './lib/cardlet/question'
require './lib/cardlet/deck'
require './lib/cardlet/persistence/deck'
require './lib/cardlet/quiz'

class DeckNotFoundError < StandardError; end

module Cardlet
  DEFAULT_DIR="#{Dir.home}/.cardlet/decks"

  def self.create_deck(name, directory=DEFAULT_DIR)
    deck = Cardlet::Deck.new(name)
    Cardlet::Persistence::Deck.write(deck, directory)
  end

  def self.list_decks(directory=DEFAULT_DIR)
    Cardlet::Persistence::Deck.index(directory)
  end

  def self.list_questions(deck, directory=DEFAULT_DIR)
    deck = get_deck(deck, directory)
    deck.questions
  end

  def self.delete(name, directory=DEFAULT_DIR)
    Cardlet::Persistence::Deck.delete(name, directory)
  end

  def self.exist?(deck, directory=DEFAULT_DIR)
    Cardlet::Persistence::Deck.exist?(deck, directory)
  end

  def self.create_card(deck, prompt, answer, directory=DEFAULT_DIR)
    deck = get_deck(deck, directory)

    card = Cardlet::Question.create({
      'type' => 'question',
      'prompt' => prompt,
      'answer' => answer
    })

    deck.add_question(card)

    Cardlet::Persistence::Deck.write(deck, directory)

    deck
  end

  def self.delete_card(deck, uuid, directory=DEFAULT_DIR)
    deck = get_deck(deck, directory)

    deck.delete_question(uuid)

    Cardlet::Persistence::Deck.write(deck, directory)

    deck
  end

  def self.tag(deck, card_uuids, tag, directory=DEFAULT_DIR)
    deck = get_deck(deck, directory)

    deck.questions.each do |card|
      card.add_tag(tag) if card_uuids.include?(card.uuid)
    end

    Cardlet::Persistence::Deck.write(deck, directory)

    deck
  end

  def self.test(deck, tag=nil, directory=DEFAULT_DIR)
    json = Cardlet::Persistence::Deck.load(deck, directory)
    hash = JSON.parse(json)
    deck = Cardlet::Deck.from_json(hash)

    quiz = Cardlet::Quiz.new(deck.cards_matching(tag))
    quiz.start
  end

  private

  def self.get_deck(deck, directory)
    raise DeckNotFoundError unless Cardlet::Persistence::Deck.exist?(deck, directory)

    deck_json = Cardlet::Persistence::Deck.load(deck, directory)
    deck_hash = JSON.parse(deck_json)
    deck = Cardlet::Deck.from_json(deck_hash)
  end
end
