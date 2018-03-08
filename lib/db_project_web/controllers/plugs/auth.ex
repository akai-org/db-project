defmodule DbProjectWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias DbProject.Accounts

  def init(options) do
    options
  end

  def call(conn, _options) do
    current_user_id = get_session(conn, :current_user_id)
    current_user = case current_user_id do
      nil ->
        nil
      _ ->
        Accounts.get_user!(current_user_id)
    end

    assign(conn, :current_user, current_user)
  end
end
