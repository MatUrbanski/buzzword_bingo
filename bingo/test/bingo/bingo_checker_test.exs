defmodule Bingo.BingoCheckerTest do
  use ExUnit.Case, async: true

  doctest Bingo.BingoChecker

  alias Bingo.{BingoChecker, Player, Square}

  describe "bingo?/1" do
    test "no squares marked" do
      squares = [
        [sq(:a), sq(:b), sq(:c)],
        [sq(:d), sq(:e), sq(:f)],
        [sq(:g), sq(:h), sq(:i)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "row not fully marked" do
      player = Player.new("A", "red")

      squares = [
        [sq(:a, player), sq(:b, player), sq(:c)],
        [sq(:d), sq(:e), sq(:f)],
        [sq(:g), sq(:h), sq(:i)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "column not fully marked" do
      player = Player.new("A", "red")

      squares = [
        [sq(:a, player), sq(:b), sq(:c)],
        [sq(:d, player), sq(:e), sq(:f)],
        [sq(:g), sq(:h), sq(:i)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "left diagonal not fully marked" do
      player = Player.new("A", "red")

      squares = [
        [sq(:a, player), sq(:b), sq(:c)],
        [sq(:d), sq(:e, player), sq(:f)],
        [sq(:g), sq(:h), sq(:i)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "right diagonal not fully marked" do
      player = Player.new("A", "red")

      squares = [
        [sq(:a), sq(:b), sq(:c, player)],
        [sq(:d), sq(:e, player), sq(:f)],
        [sq(:g), sq(:h), sq(:i)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "row marked by different players" do
      player_1 = Player.new("A", "red")
      player_2 = Player.new("B", "blue")

      squares = [
        [sq(:a, player_1), sq(:b, player_2), sq(:c, player_2)],
        [sq(:d), sq(:e), sq(:f)],
        [sq(:g), sq(:h), sq(:i)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "column marked by different players" do
      player_1 = Player.new("A", "red")
      player_2 = Player.new("B", "blue")

      squares = [
        [sq(:a, player_1), sq(:b), sq(:c)],
        [sq(:d, player_1), sq(:e), sq(:f)],
        [sq(:g, player_2), sq(:h), sq(:i)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "left diagonal marked by different players" do
      player_1 = Player.new("A", "red")
      player_2 = Player.new("B", "blue")

      squares = [
        [sq(:a, player_1), sq(:b), sq(:c)],
        [sq(:d), sq(:e, player_1), sq(:f)],
        [sq(:g), sq(:h), sq(:i, player_2)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "right diagonal marked by different players" do
      player_1 = Player.new("A", "red")
      player_2 = Player.new("B", "blue")

      squares = [
        [sq(:a), sq(:b), sq(:c, player_1)],
        [sq(:d), sq(:e, player_1), sq(:f)],
        [sq(:g, player_2), sq(:h), sq(:i)]
      ]

      refute BingoChecker.bingo?(squares)
    end

    test "row bingo" do
      player = Player.new("A", "red")

      squares = [
        [sq(:a, player), sq(:b, player), sq(:c, player)],
        [sq(:d), sq(:e), sq(:f)],
        [sq(:g), sq(:h), sq(:i)]
      ]

      assert BingoChecker.bingo?(squares)
    end

    test "column bingo" do
      player = Player.new("A", "red")

      squares = [
        [sq(:a, player), sq(:b), sq(:c)],
        [sq(:d, player), sq(:e), sq(:f)],
        [sq(:g, player), sq(:h), sq(:i)]
      ]

      assert BingoChecker.bingo?(squares)
    end

    test "left diagonal bingo" do
      player = Player.new("A", "red")

      squares = [
        [sq(:a, player), sq(:b), sq(:c)],
        [sq(:d), sq(:e, player), sq(:f)],
        [sq(:g), sq(:h), sq(:i, player)]
      ]

      assert BingoChecker.bingo?(squares)
    end

    test "right diagonal bingo" do
      player = Player.new("A", "red")

      squares = [
        [sq(:a), sq(:b), sq(:c, player)],
        [sq(:d), sq(:e, player), sq(:f)],
        [sq(:g, player), sq(:h), sq(:i)]
      ]

      assert BingoChecker.bingo?(squares)
    end
  end

  describe "possible_winning_square_sequences/1" do
    test "returns list of possible winning sequences" do
      squares = [
        [sq(:a), sq(:b), sq(:c)],
        [sq(:d), sq(:e), sq(:f)],
        [sq(:g), sq(:h), sq(:i)]
      ]

      assert BingoChecker.possible_winning_square_sequences(squares) ==
               [
                 # rows
                 [sq(:a), sq(:b), sq(:c)],
                 [sq(:d), sq(:e), sq(:f)],
                 [sq(:g), sq(:h), sq(:i)],
                 # columns
                 [sq(:a), sq(:d), sq(:g)],
                 [sq(:b), sq(:e), sq(:h)],
                 [sq(:c), sq(:f), sq(:i)],
                 # left diagonal
                 [sq(:a), sq(:e), sq(:i)],
                 # right diagonal
                 [sq(:c), sq(:e), sq(:g)]
               ]
    end
  end

  describe "sequences_with_at_least_one_square_marked/1" do
    test "returns sequences with at least one square marked" do
      player_1 = Player.new("A", "red")
      player_2 = Player.new("B", "blue")

      squares = [
        [sq(:a, player_1), sq(:b, nil), sq(:c, nil)],
        [sq(:d, nil), sq(:e, nil), sq(:f, nil)],
        [sq(:g, player_2), sq(:g, player_1), sq(:i, player_2)]
      ]

      assert BingoChecker.sequences_with_at_least_one_square_marked(squares) ==
               [
                 [sq(:a, player_1), sq(:b, nil), sq(:c, nil)],
                 [sq(:g, player_2), sq(:g, player_1), sq(:i, player_2)]
               ]
    end
  end

  describe "all_squares_marked_by_same_player?/1" do
    test "it returns true if all squares are marked by the same player, otherwise false" do
      player_1 = Player.new("A", "red")
      player_2 = Player.new("B", "blue")

      squares = [sq(:a, player_1), sq(:b, nil), sq(:c, nil)]

      refute BingoChecker.all_squares_marked_by_same_player?(squares)

      squares = [sq(:a, player_1), sq(:b, player_1), sq(:c, player_2)]

      refute BingoChecker.all_squares_marked_by_same_player?(squares)

      squares = [sq(:a, player_1), sq(:b, player_1), sq(:c, player_1)]

      assert BingoChecker.all_squares_marked_by_same_player?(squares)
    end
  end

  describe "transpose/1" do
    test "returns a new 2D list where the row and column indices have been switched" do
      squares = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      assert BingoChecker.transpose(squares) == [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
    end
  end

  describe "rotate_90_degrees/1" do
    test "rotates the given 2D list of elements 90 degrees" do
      squares = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      assert BingoChecker.rotate_90_degrees(squares) == [[3, 6, 9], [2, 5, 8], [1, 4, 7]]
    end
  end

  describe "left_diagonal_squares/1" do
    test "returns the elements on the left diagonal of the given 2D list" do
      squares = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      assert BingoChecker.left_diagonal_squares(squares) == [1, 5, 9]
    end
  end

  describe "right_diagonal_squares/1" do
    test "returns the elements on the right diagonal of the given 2D list" do
      squares = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      assert BingoChecker.right_diagonal_squares(squares) == [3, 5, 7]
    end
  end

  defp sq(phrase, marked_by \\ nil) do
    %Square{phrase: phrase, points: 10, marked_by: marked_by}
  end
end
