defmodule PlaygroundWeb.PageController do
  use PlaygroundWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
