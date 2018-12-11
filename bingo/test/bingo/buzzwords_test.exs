defmodule Bingo.BuzzwordsTest do
  use ExUnit.Case, async: true

  alias Bingo.Buzzwords

  describe "read_buzzwords/0" do
    test "returns list of Buzzwords" do
      buzzwords = Buzzwords.read_buzzwords()

      assert Enum.count(buzzwords) == 106
      assert List.first(buzzwords) == %{phrase: "Above My Pay Grade", points: 400}
    end
  end
end
