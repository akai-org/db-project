defmodule DbProjectWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias DbProject.Accounts.User

  def init(options) do
    options
  end

  def call(conn, _options) do
    current_user = get_session(conn, :current_user)
    assign(conn, :current_user, current_user)
  end
end
