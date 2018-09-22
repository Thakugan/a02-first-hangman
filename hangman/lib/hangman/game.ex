defmodule Hangman.Game do
  defmodule State do
    defstruct(
      game_state: :initializing,
      turns_left: 7,
      letters: [],
      used: [],
      last_guessed: ""
    )
  end

  # API

  # Returns a struct representing a new game
  def new_game() do
    %Hangman.Game.State{letters: random_word()}
  end

  # Returns the tally for the given game
  def tally(game = %Hangman.Game.State{}) do
    letters =
      game.letters
      |> tally_letters(game.used)

    %{
      game_state:   game.game_state,
      turns_left:   game.turns_left,
      letters:       letters,
      used:         game.used,
      last_guessed: game.last_guessed
    }
  end

  # Helpers

  # Returns a random word split into a list of chars
  defp random_word() do
    Dictionary.random_word()
    |> String.codepoints()
  end

  # Returns the list of letters with unguessed letters
  # hidden with an underscore
  defp tally_letters(letters, used) do
    letters
    |> Enum.map(&guessed_letter(&1, Enum.member?(used, &1)))
  end

  defp guessed_letter(letter, true), do: letter
  defp guessed_letter(_, false),     do: "_"
end
