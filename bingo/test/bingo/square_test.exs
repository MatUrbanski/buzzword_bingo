defmodule Bingo.SquareTest do
  use ExUnit.Case, async: true

  alias Bingo.Square

  describe "new/2" do
    test "creates a square from a buzzword" do
      phrase = "A"
      points = 10
      square = Square.new(phrase, points)

      assert square.phrase == "A"
      assert square.points == 10
    end
  end

  describe "from_buzzword/1" do
    test "creates a square from a buzzword" do
      buzzword = %{phrase: "A", points: 10}
      square = Square.from_buzzword(buzzword)

      assert square.phrase == "A"
      assert square.points == 10
    end
  end
end
