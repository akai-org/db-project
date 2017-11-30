defmodule DbProjectWeb.AuthController do
  use DbProjectWeb, :controller
  plug Ueberauth
  alias DbProject.Accounts

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
  #  conn
  #  |> put_flash(:error, "Failed to authenticate.")
  #  |> redirect(to: "/")
    text conn, "Error"
 end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, %Accounts.User{} = user} <- Accounts.auth_user(auth) do
        conn
          |> put_flash(:info, "Zalogowano")
          |> put_session(:current_user, user)
          |> redirect(to: page_path(conn, :index))
    else
        {:error, :wrong_domain} -> conn |> put_flash(:error, "Zła domena") |> redirect(to: page_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} -> conn |> put_flash(:error, "Błąd bazy danych") |> redirect(to: page_path(conn, :index))
    end
  end
end
