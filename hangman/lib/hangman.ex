defmodule Hangman do
  defdelegate new_game(),  to: Hangman.Game
  defdelegate tally(game), to: Hangman.Game
end
