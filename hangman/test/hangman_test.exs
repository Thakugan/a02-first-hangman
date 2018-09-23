defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "create new game" do
    assert Hangman.new_game().letters != []
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

  test "tally hides all letters initially" do
    game = %Hangman.Game.State{
      game_state:   :initializing,
      turns_left:   7,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         [],
      last_guessed: ""
    }

    assert Hangman.tally(game).letters == ["_", "_", "_", "_", "_", "_"]
  end

  test "tally doesn't hide any letters after a win" do
    game = %Hangman.Game.State{
      game_state:   :won,
      turns_left:   6,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["e", "i", "l", "r", "x", "z"],
      last_guessed: "e"
    }

    assert Hangman.tally(game).letters == ["e", "l", "i", "x", "i", "r"]
  end
end
