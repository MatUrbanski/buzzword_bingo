defmodule Bingo.Player do
  @enforce_keys [:name, :color]
  @derive Jason.Encoder
  defstruct [:name, :color]

  alias Bingo.Player

  @doc """
  Creates a player with the given `name` and `color`.
  """
  def new(name, color) do
    %Player{name: name, color: color}
  end
end
