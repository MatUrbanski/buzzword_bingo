defmodule Bingo.BingoChecker do
  @doc """
  Checks for a bingo!

  Given a 2D list of `squares`, returns `true` if all the squares of
  any row, column, or diagonal have been marked by the same player.
  Otherwise `false` is returned.
  """
  def bingo?(squares) do
    possible_winning_square_sequences(squares)
    |> sequences_with_at_least_one_square_marked()
    |> Enum.map(&all_squares_marked_by_same_player?(&1))
    |> Enum.any?()
  end

  @doc """
  Given a 2D list of `squares`, returns a 2D list of all possible winning square sequences: rows, columns, left diagonal, and right diagonal.
  """
  def possible_winning_square_sequences(squares) do
    squares ++
      transpose(squares) ++ [left_diagonal_squares(squares), right_diagonal_squares(squares)]
  end

  @doc """
  Given a list of possible winning square sequences, returns a list of
  those sequences that have at least one square marked.
  """
  def sequences_with_at_least_one_square_marked(squares) do
    Enum.reject(squares, fn sequence ->
      Enum.reject(sequence, &is_nil(&1.marked_by)) |> Enum.empty?()
    end)
  end

  @doc """
  Given a list of possible winning square sequences, returns `true` if
  the sequence has all squares marked by the same player.
  Otherwise, returns `false`.
  """
  def all_squares_marked_by_same_player?(squares) do
    first_square = Enum.at(squares, 0)

    Enum.all?(squares, fn s ->
      s.marked_by == first_square.marked_by
    end)
  end

  @doc """
  Given a 2D list of elements, returns a new 2D list where the
  row and column indices have been switched. In other words,
  it flips the given matrix over its left diagonal.
  """
  def transpose(squares) do
    squares
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Rotates the given 2D list of elements 90 degrees.
  """
  def rotate_90_degrees(squares) do
    squares
    |> transpose()
    |> Enum.reverse()
  end

  @doc """
  Returns the elements on the left diagonal of the given 2D list.
  """
  def left_diagonal_squares(squares) do
    squares
    |> List.flatten()
    |> Enum.take_every(Enum.count(squares) + 1)
  end

  @doc """
  Returns the elements on the right diagonal of the given 2D list.
  """
  def right_diagonal_squares(squares) do
    squares
    |> rotate_90_degrees()
    |> left_diagonal_squares()
  end
end
