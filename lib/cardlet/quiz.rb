module Cardlet
  class Response
    def initialize(response, card)
      @card = card
      @response = response
    end

    def correct?
      @card.correct?(@response)
    end
  end

  class Quiz
    def initialize(cards, shuffle=true)
      @cards = shuffled(cards, shuffle)
      @correct = []
      @incorrect = []
    end

    def start
      ask_cards(@cards)
      give_feedback(@cards.length, @correct.length, @incorrect.length)
    end

    private

    class AskQuestion
      def run(card)
        puts card.prompt
        response = STDIN.gets.chomp

        Cardlet::Response.new(response, card)
      end
    end

    class AskFacetedQuestion
      def run(card)
        puts card.prompt
        response = []
        input = STDIN.gets.chomp
        until input.empty?
          response << input
          input = STDIN.gets.chomp
        end

        Cardlet::Response.new(response, card)
      end
    end

    def ask(card)
      askers = {
        'question' => AskQuestion,
        'faceted_question' => AskFacetedQuestion
      }

      askers[card.type].new.run(card)
    end

    def ask_cards(cards)
      @cards.each do |card|
        response = ask(card)

        if response.correct?
          congratulate
          @correct << card
        else
          correct(card)
          @incorrect << card
        end
      end
    end

    def congratulate
      puts "Way to go!"
      puts
    end

    def correct(card)
      puts "Almost - the correct answer is: #{card.answer}"
      puts
    end

    def give_feedback(card_count, correct_count, incorrect_count)
      percentage = Float(correct_count) / card_count * 100

      puts <<-EOF
      You got #{correct_count} cards right out of #{card_count}.
      That means you got #{percentage}% correct.
      EOF

      if percentage >= 95
        puts "Great job - keep up the great work!"
      else
        puts "Keep practicing to raise your score."
      end
    end

    def shuffled(cards, shuffle)
      return cards.shuffle if shuffle
      return cards
    end
  end
end
