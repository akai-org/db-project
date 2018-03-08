defmodule DbProjectWeb.RequireRole do
  import Plug.Conn
  import DbProjectWeb.Router.Helpers
  import Phoenix.Controller

  alias DbProject.Accounts

  def init(options) do
    options
  end

  def call(conn, options) do
    required_role = options[:role]
    current_user = conn.assigns.current_user
    IO.inspect(Accounts.has_role(current_user, required_role))
    case Accounts.has_role(current_user, required_role) do
      true ->
        conn
      false ->
        conn
        |> put_flash(:error, "You don't have permission to visit that page")
        |> redirect(to: page_path(conn, :index))
    end
  end
end