defmodule DbProjectWeb.PageController do
  use DbProjectWeb, :controller

  plug DbProjectWeb.RequireLogin when action in [:admin]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def admin(conn, _params) do
    render conn, "admin.html"
  end
end
