defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "create new game" do
    assert Hangman.new_game()
  end

  test "tally hides unguessed letters" do
    game = %Hangman.Game.State{
      game_state:   :good_guess,
      turns_left:   6,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["e", "x", "z"],
      last_guessed: "e"
    }

    assert Hangman.tally(game).letters == ["e", "_", "_", "x", "_", "_"]
  end
end
