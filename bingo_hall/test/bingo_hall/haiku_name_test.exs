defmodule BingoHall.HaikuNameTest do
  use ExUnit.Case, async: true

  alias BingoHall.HaikuName

  describe "generate/1" do
    test "Generates a unique, URL-friendly name" do
      name = HaikuName.generate()

      assert String.length(name) > 0
    end
  end
end
