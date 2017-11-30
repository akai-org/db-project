defmodule DbProjectWeb.PageController do
  use DbProjectWeb, :controller

  plug DbProject.Accounts.RequireLogin when action in [:admin]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def admin(conn, _params) do
    text conn, "Admin"
  end
end
