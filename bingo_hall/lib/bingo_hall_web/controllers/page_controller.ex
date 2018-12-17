defmodule BingoHallWeb.PageController do
  use BingoHallWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
