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

  def new_game() do
    %Hangman.Game.State{letters: random_word()}
  end

  def random_word() do
    Dictionary.random_word()
    |> String.codepoints()
  end
end
