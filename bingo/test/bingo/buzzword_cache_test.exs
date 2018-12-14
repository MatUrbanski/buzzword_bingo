defmodule Bingo.BuzzwordCacheTest do
  use ExUnit.Case, async: true

  alias Bingo.BuzzwordCache

  describe "get_buzzwords/1" do
    test "returns cached buzzwords" do
      buzzwords = BuzzwordCache.get_buzzwords()

      assert %{phrase: _, points: _} = List.first(buzzwords)
    end
  end
end
