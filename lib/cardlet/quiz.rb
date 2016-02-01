module Cardlet
  class Response
    def initialize(response, question)
      @question = question
      @response = response
    end

    def correct?
      @question.answer == @response
    end
  end

  class Quiz
    def initialize(questions, shuffle=true)
      @questions = shuffled(questions, shuffle)
      @correct = []
      @incorrect = []
    end

    def start
      ask_questions(@questions)
      give_feedback(@questions.length, @correct.length, @incorrect.length)
    end

    private

    def ask(question)
      puts question.prompt
      response = STDIN.gets.chomp
      Cardlet::Response.new(response, question)
    end

    def ask_questions(questions)
      @questions.each do |question|
        response = ask(question)

        if response.correct?
          congratulate
          @correct << question
        else
          correct(question)
          @incorrect << question
        end
      end
    end

    def congratulate
      puts "Way to go!"
      puts
    end

    def correct(question)
      puts "Almost - the correct answer is: #{question.answer}"
      puts
    end

    def give_feedback(question_count, correct_count, incorrect_count)
      percentage = Float(correct_count) / question_count * 100

      puts <<-EOF
      You got #{correct_count} questions right out of #{question_count}.
      That means you got #{percentage}% correct.
      EOF

      if percentage >= 95
        puts "Great job - keep up the great work!"
      else
        puts "Keep practicing to raise your score."
      end
    end

    def shuffled(questions, shuffle)
      return questions.shuffle if shuffle
      return questions
    end
  end
end
