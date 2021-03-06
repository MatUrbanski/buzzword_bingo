defmodule Bingo.Square do
  @enforce_keys [:phrase, :points]
  @derive Jason.Encoder
  defstruct [:phrase, :points, :marked_by]

  alias Bingo.Square

  @doc """
  Creates a square from the given `phrase` and `points`.
  """
  def new(phrase, points) do
    %Square{phrase: phrase, points: points}
  end

  @doc """
  Creates a square from the given map with `:phrase` and `:points` keys.
  """
  def from_buzzword(%{phrase: phrase, points: points}) do
    Square.new(phrase, points)
  end
end
