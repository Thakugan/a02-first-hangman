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
      last_guess:   "e"
    }

    assert Hangman.tally(game).letters == ["e", "_", "_", "x", "_", "_"]
  end

  test "tally hides all letters initially" do
    game = %Hangman.Game.State{
      game_state:   :initializing,
      turns_left:   7,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         [],
      last_guess:   ""
    }

    assert Hangman.tally(game).letters == ["_", "_", "_", "_", "_", "_"]
  end

  test "tally doesn't hide any letters after a win" do
    game = %Hangman.Game.State{
      game_state:   :won,
      turns_left:   6,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["e", "i", "l", "r", "x", "z"],
      last_guess:   "e"
    }

    assert Hangman.tally(game).letters == ["e", "l", "i", "x", "i", "r"]
  end

  test "tally doesn't hide any letters after a loss" do
    game = %Hangman.Game.State{
      game_state:   :lost,
      turns_left:   6,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["e", "i", "l", "r", "x", "z"],
      last_guess:   "e"
    }

    assert Hangman.tally(game).letters == ["e", "l", "i", "x", "i", "r"]
  end

  test "make move updates won status" do
    game = %Hangman.Game.State{
      game_state:   :good_guess,
      turns_left:   6,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["e", "l", "r", "x", "z"],
      last_guess:   "e"
    }

    {game, _} = Hangman.make_move(game, "i")
    assert game.game_state == :won
  end

  test "make move updates lost status" do
    game = %Hangman.Game.State{
      game_state:   :good_guess,
      turns_left:   1,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["a", "b", "c", "d", "e", "f", "z"],
      last_guess:   "e"
    }

    {game, _} = Hangman.make_move(game, "t")
    assert game.game_state == :lost
  end

  test "make move updates already used status" do
    game = %Hangman.Game.State{
      game_state:   :good_guess,
      turns_left:   6,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["e", "l", "r", "x", "z"],
      last_guess:   "e"
    }

    {game, _} = Hangman.make_move(game, "e")
    assert game.game_state == :already_used
  end

  test "make move updates good guess status" do
    game = %Hangman.Game.State{
      game_state:   :good_guess,
      turns_left:   6,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["e", "l", "x", "z"],
      last_guess:   "e"
    }

    {game, _} = Hangman.make_move(game, "r")
    assert game.game_state == :good_guess
  end

  test "make move updates bad guess status" do
    game = %Hangman.Game.State{
      game_state:   :good_guess,
      turns_left:   6,
      letters:      ["e", "l", "i", "x", "i", "r"],
      used:         ["e", "l", "r", "x", "z"],
      last_guess:   "e"
    }

    {game, _} = Hangman.make_move(game, "s")
    assert game.game_state == :bad_guess
  end
end
