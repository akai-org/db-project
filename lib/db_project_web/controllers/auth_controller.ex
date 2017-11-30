defmodule DbProjectWeb.AuthController do
  use DbProjectWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
  #  conn
  #  |> put_flash(:error, "Failed to authenticate.")
  #  |> redirect(to: "/")
    text conn, "Error"
 end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect(auth)

    text conn, "OK"
  end
end
