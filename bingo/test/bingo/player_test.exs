defmodule Bingo.PlayerTest do
  use ExUnit.Case, async: true

  alias Bingo.Player

  describe "new/2" do
    test "creates a Player" do
      name = "Mat"
      color = "Green"
      player = Player.new(name, color)

      assert player.name == "Mat"
      assert player.color == "Green"
    end
  end
end
