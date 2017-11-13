defmodule DbProjectWeb.PageController do
  use DbProjectWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
