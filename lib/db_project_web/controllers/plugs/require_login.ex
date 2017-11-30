defmodule DbProjectWeb.RequireLogin do
  import Plug.Conn
  import DbProjectWeb.Router.Helpers
  import Phoenix.Controller

  alias DbProject.Accounts.User

  def init(options) do
    options
  end

  def call(conn, _options) do
    current_user = conn.assigns.current_user
    case current_user do
      %User{} -> conn
      _       -> conn
                |> put_flash(:error, "Musisz sie zalogowac")
                |> redirect(to: page_path(conn, :index))
    end
  end
end
