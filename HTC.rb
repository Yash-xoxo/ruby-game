require 'tk'

class HackTheCodeGame
  def initialize
    @root = TkRoot.new { title "Hack the Code" }
    @code = generate_code
    @max_attempts = 10
    @attempts = 0

    setup_gui
  end

  # Generates a random 4-digit code
  def generate_code
    Array.new(4) { rand(1..9) }
  end

  # Compares guess to the code
  def check_guess(guess)
    guess_array = guess.chars.map(&:to_i)
    correct_digits = 0
    correct_positions = 0

    guess_array.each_with_index do |digit, index|
      if digit == @code[index]
        correct_positions += 1
      elsif @code.include?(digit)
        correct_digits += 1
      end
    end

    { correct_digits: correct_digits, correct_positions: correct_positions }
  end

  # Sets up the GUI layout
  def setup_gui
    # Welcome label
    @welcome_label = TkLabel.new(@root) do
      text 'Welcome to Hack the Code!'
      pack(padx: 10, pady: 10)
    end

    # Guess input field
    @guess_label = TkLabel.new(@root) do
      text 'Enter your 4-digit guess:'
      pack(padx: 10, pady: 5)
    end

    @guess_entry = TkEntry.new(@root) do
      width 5
      pack(padx: 10, pady: 5)
    end

    # Feedback label
    @feedback_label = TkLabel.new(@root) do
      text 'Feedback will appear here...'
      pack(padx: 10, pady: 10)
    end

    # Button to submit guess
    TkButton.new(@root) do
      text 'Submit Guess'
      command { submit_guess }
      pack(padx: 10, pady: 10)
    end

    # Reset button
    TkButton.new(@root) do
      text 'Start New Game'
      command { reset_game }
      pack(padx: 10, pady: 5)
    end
  end

  # Handles the guess submission
  def submit_guess
    guess = @guess_entry.get
    if guess.length != 4 || !guess.match?(/^\d+$/)
      @feedback_label.text = "Please enter a valid 4-digit number."
      return
    end

    @attempts += 1
    result = check_guess(guess)

    if result[:correct_positions] == 4
      @feedback_label.text = "Congratulations! You've hacked the code!"
    elsif @attempts >= @max_attempts
      @feedback_label.text = "Game over! The correct code was #{@code.join}."
    else
      @feedback_label.text = "Correct digits: #{result[:correct_digits]}, Correct positions: #{result[:correct_positions]}"
    end

    @guess_entry.delete(0, 'end')
  end

  # Resets the game
  def reset_game
    @code = generate_code
    @attempts = 0
    @feedback_label.text = 'Feedback will appear here...'
    @guess_entry.delete(0, 'end')
  end

  # Starts the Tk main loop
  def start
    Tk.mainloop
  end
end

# Initialize and start the game
game = HackTheCodeGame.new
game.start
