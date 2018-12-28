defmodule BingoHallWeb.SessionControllerTest do
  use BingoHallWeb.ConnCase

  alias Bingo.Player

  describe "new/2" do
    setup do
      conn = build_conn()
      conn = get(conn, Routes.session_path(conn, :new))

      {:ok, conn: conn}
    end

    test "renders form", %{conn: conn} do
      assert html_response(conn, 200) =~ "Play Bingo"
    end
  end

  describe "create/2" do
    test "adds player to session", %{conn: conn} do
      attrs = %{"name" => "mat", "color" => "blue"}
      conn = post(conn, Routes.session_path(conn, :create), player: attrs)
      expected_player = %Player{name: "mat", color: "blue"}

      assert Plug.Conn.get_session(conn, :current_player) == expected_player
      assert redirected_to(conn) == Routes.game_path(conn, :new)
    end
  end

  describe "delete session" do
    test "deletes player from session", %{conn: conn} do
      conn = put_player_in_session(conn, "mike")
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert redirected_to(conn) == "/"
      assert Plug.Conn.get_session(conn, :current_player) == nil
    end
  end
end
