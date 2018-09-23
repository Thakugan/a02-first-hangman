defmodule Hangman.Game do
  defmodule State do
    defstruct(
      game_state:   :initializing,
      turns_left:   7,
      letters:      [],
      used:         [],
      last_guess:   ""
    )
  end

  # API

  # Returns a struct representing a new game
  def new_game() do
    %Hangman.Game.State{letters: random_word()}
  end

  # Returns the tally for the given game
  # If the game has already been won or lost,
  # no letters are hidden
  def tally(game = %Hangman.Game.State{game_state: :won}),  do: game
  def tally(game = %Hangman.Game.State{game_state: :lost}), do: game

  def tally(game = %Hangman.Game.State{}) do
    letters = game.letters |> tally_letters(game.used)

    %Hangman.Game.State{ game | letters: letters }
  end

  # Returns a tuple containing the updated game state
  # and a tally
  def make_move(game = %Hangman.Game.State{}, guess) do
    updated_state = game
      |> update_guesses(guess)
      |> update_status(game.used)

    { updated_state, Hangman.tally(updated_state) }
  end

  # Helpers

  # Returns a random word split into a list of chars
  defp random_word() do
    Dictionary.random_word()
    |> String.codepoints()
  end

  # Returns the list of letters with unguessed letters
  # hidden with an underscore
  #
  # Note: The extra computation can be saved by storing the word and
  #       letters separately then updating letters with each guess but
  #       this isn't an expensive operation and seems more functional
  defp tally_letters(letters, used) do
    letters
    |> Enum.map(&guessed_correct_letter(&1, Enum.member?(used, &1)))
  end

  defp guessed_correct_letter(letter, true), do: letter
  defp guessed_correct_letter(_, _),         do: "_"

  # Updates the game state to include the latest guess
  defp update_guesses(game = %Hangman.Game.State{}, guess) do
    %Hangman.Game.State{ game |
      used: game.used
        |> MapSet.new()
        |> MapSet.put(guess)
        |> MapSet.to_list()
        |> Enum.sort(),
      last_guess: guess
    }
  end

  # Updates the game status based on the latest guess
  defp update_status(game = %Hangman.Game.State{}, prev_guesses) do
    %Hangman.Game.State{ game |
      game_state: get_status(game, prev_guesses),
      turns_left: game.turns_left - 1
    }
  end

  defp get_status(game = %Hangman.Game.State{}, prev_guesses) do
    check_status({
      game.letters,
      tally_letters(game.letters, game.used),
      tally_letters(game.letters, prev_guesses),
      game.used,
      prev_guesses,
      game.turns_left})
  end

  # Pattern matching to find the new game status,
  # this should be refactored
  #
  # Won when the tally == letters
  defp check_status({letters, letters, _, _, _, _}), do: :won
  # Lost when only 1 turn is left(before deprecation)
  defp check_status({_, _, _, _, _, 1}),             do: :lost
  # Already used if the current and prev used lists are the same
  defp check_status({_, _, _, used, used, _}),       do: :already_used
  # Bad guess if the tally hasn't changed
  defp check_status({_, tally, tally, _, _, _}),     do: :bad_guess
  # Good guess otherwise
  defp check_status(_),                              do: :good_guess
end
